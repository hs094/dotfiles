#!/usr/bin/env node

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Add Youtube Video
// @raycast.mode silent

// Optional parameters:
// @raycast.icon youtube.svg 
// @raycast.key ctrl+cmd+y
// @raycast.description Add a Video to Youtube DB Page
// @raycast.argument1 { "type": "url", "placeholder": "Youtube Video URL", "optional": true }

// Documentation:
// @raycast.author hs094
// @raycast.authorURL https://raycast.com/hs094


import { execSync } from "node:child_process"
import { Client } from "@notionhq/client"

process.loadEnvFile(`${import.meta.dirname}/.env`)

function getBrowserUrl() {
  // ponytail: tries common browsers via osascript, silent on miss
  const scripts = [
    'tell application "Google Chrome" to get URL of active tab of front window',
    'tell application "Safari" to get URL of current tab of front window',
    'tell application "Arc" to get URL of active tab of front window',
    'tell application "Brave Browser" to get URL of active tab of front window',
    'tell application "Microsoft Edge" to get URL of active tab of front window',
  ]
  for (const script of scripts) {
    try {
      return execSync(`osascript -e ${JSON.stringify(script)}`, {
        encoding: "utf-8",
        timeout: 2000,
        stdio: ["pipe", "pipe", "ignore"],
      }).trim()
    } catch {
      // try next browser
    }
  }
  throw new Error("Could not get URL from any browser tab")
}

// Validate that the argument is a YouTube video link and return a canonical
// https://www.youtube.com/watch?v=ID URL, preserving playlist params (list,
// index) and an optional timestamp.
function normalizeYoutubeUrl(input) {
  let url
  try {
    url = new URL(input.trim())
  } catch {
    throw new Error(`Not a valid URL: ${input}`)
  }

  const host = url.hostname.replace(/^www\./, "")
  let videoId

  if (host === "youtu.be") {
    videoId = url.pathname.slice(1)
  } else if (["youtube.com", "m.youtube.com", "music.youtube.com"].includes(host)) {
    if (url.pathname === "/watch") {
      videoId = url.searchParams.get("v")
    } else {
      const m = url.pathname.match(/^\/(?:shorts|embed|live|v)\/([^/]+)/)
      videoId = m?.[1]
    }
  } else {
    throw new Error(`Not a YouTube link: ${input}`)
  }

  if (!videoId || !/^[A-Za-z0-9_-]{11}$/.test(videoId)) {
    throw new Error(`Could not find a YouTube video ID in: ${input}`)
  }

  const clean = new URL("https://www.youtube.com/watch")
  clean.searchParams.set("v", videoId)
  for (const key of ["list", "index", "t"]) {
    const value = url.searchParams.get(key)
    if (value) clean.searchParams.set(key, value)
  }
  return clean.toString()
}

const rawUrl = process.argv[2]?.trim() || getBrowserUrl()

let videoUrl
try {
  videoUrl = normalizeYoutubeUrl(rawUrl)
} catch (err) {
  console.error(err.message)
  process.exit(1)
}

const notion = new Client({ auth: process.env.NOTION_API_KEY })
const response = await notion.pages.create({
  parent: {
    data_source_id: "21f11c95-6c7b-4d66-9450-66561b1f072c"
  },
  properties: {
    Link: {
      url: videoUrl
    }
  }
})
console.log("Added Youtube URL")

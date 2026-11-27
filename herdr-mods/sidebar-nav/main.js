import { View, div, svg } from "gpui-kit";
import { HoverCard, h_flex, v_flex } from "gpui-base";
import { exec, run, shared, theme } from "herdr";

const LINKS = [
  ["automations", "Automations", "mods/sidebar-nav/automations.svg"],
  ["issues", "Issues", "mods/sidebar-nav/issues.svg"],
  ["better-config", "Mod settings", "mods/sidebar-nav/settings.svg"],
];

export default class SidebarNav extends View {
  issuePreview(t) {
    const preview = this.preview ?? shared("issues.hoverPreview");
    const items = preview?.items ?? [];
    const body = v_flex().w(320).p(12).gap(8).rounded(10).border_1().border_color(t.border).bg(t.chrome).text_size(12)
      .child(h_flex().items_center().justify_between()
        .child(div().font_semibold().child("Assigned to me"))
        .child(div().text_color(t.dim).text_size(10).child("Open issues")));
    if (!preview) return body.child(div().text_color(t.dim).child("Open Issues once to load a preview."));
    if (!items.length) return body.child(div().text_color(t.dim).child("No open issues assigned to you."));
    return body.children(items.map((item) =>
      h_flex().id("issue-preview-" + item.number).h(30).gap(8).items_center().rounded(6).px(6).cursor_pointer()
        .hover((s) => s.bg(t.hover))
        .on_click(() => item.url && exec("open", [item.url]))
        .child(div().text_color(t.dim).text_size(10.5).flex_none().child("#" + item.number))
        .child(div().flex_1().min_w(0).truncate().child(item.title))));
  }

  render() {
    const t = theme();
    return h_flex().id("sidebar-nav").size_full().items_center().bg(t.chrome)
      .children(LINKS.map(([mod, label, icon]) => {
        const slot = h_flex().id("slot-" + mod).flex_1().min_w(0).items_center().justify_center();
        const button = h_flex().id("nav-" + mod).size(36).items_center().justify_center().rounded(7).cursor_pointer()
          .text_color(t.muted).hover((s) => s.bg(t.hover).text_color(t.foreground))
          .role("button").accessibility_label(label)
          .when(mod !== "issues", (el) => el.tooltip(label))
          .on_click(() => run("mod.open", { name: mod }))
          .child(svg(icon).size(18).flex_none());
        if (mod !== "issues") return slot.child(button);
        const trigger = button.on_hover((on, cx) => {
          if (on) { this.preview = shared("issues.hoverPreview"); cx.notify(); }
        });
        return slot.child(HoverCard.new("sidebar-issues-preview").anchor("bottom_left").open_delay(350).close_delay(300)
          .trigger(trigger)
          .content(this.issuePreview(t)));
      }));
  }
}

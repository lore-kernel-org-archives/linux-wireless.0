Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:53039 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3G2QYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 12:24:13 -0400
Received: by mail-ob0-f173.google.com with SMTP id ta17so37493obb.18
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jul 2013 09:24:13 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: m@bues.ch
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [RFC/RFT] fwcutter: Add firmware 6.30.163.46
Date: Mon, 29 Jul 2013 11:23:45 -0500
Message-Id: <1375115025-26851-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130729_182418_295763_A49F44B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This firmware version can be extracted from the GPL tarball for the ASUS
GPL code for the RT-AC66U 802.11ac Dual-Band Wireless-AC1750 Gigabit Router.

I believe this to be the first instance of 802.11ac firmware for Broadcom
hardware. The firmware is version 784.2.

Note: The http://www.lwfinger.com/broadcom-wl-6.30.163.46.tar.bz2 is the URL
of the extracted apsta binary. The full GPL package is at
http://dlcdnet.asus.com/pub/ASUS/wireless/RT-AC66U/GPL_RT_AC66U_3004372.zip.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Michael and list,

Is this change worthwhile? This driver implements through ucode43, thus it covers a
lot of PHY revisions not currently available. I have no idea if there are any firmware
changes for boards that are currently supported by b43.

Larry
---

 fwcutter/fwcutter_list.h | 181 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 181 insertions(+)

diff --git a/fwcutter/fwcutter_list.h b/fwcutter/fwcutter_list.h
index f84607f..4e0c07a 100644
--- a/fwcutter/fwcutter_list.h
+++ b/fwcutter/fwcutter_list.h
@@ -771,6 +771,179 @@ static struct extract _e1b05e268bcdbfef3560c28fc161f30e[] =
 	EXTRACT_LIST_END
 };
 
+static struct extract _29c8a47094fbae342902d84881a465ff[] =
+{
+	{ .name = "lcn1bsinitvals26", .offset = 0x22CF88, .type = EXT_IV, .length = 0x118 },
+	{ .name = "n0bsinitvals22", .offset = 0x28D3D8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lcn0bsinitvals26", .offset = 0x22BF18, .type = EXT_IV, .length = 0x118 },
+	{ .name = "ac1bsinitvals42", .offset = 0x274530, .type = EXT_IV, .length = 0x248 },
+	{ .name = "ucode24_lcn", .offset = 0x23AF24, .type = EXT_UCODE_3, .length = 0x891A },
+	/* ucode minor version at offset 0x288284 */
+	{ .name = "ht0bsinitvals26", .offset = 0x22F068, .type = EXT_IV, .length = 0x118 },
+	{ .name = "ucode24_mimo", .offset = 0x231300, .type = EXT_UCODE_3, .length = 0x9C20 },
+	{ .name = "n20initvals36", .offset = 0x2312D0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ucode15", .offset = 0x2E86A0, .type = EXT_UCODE_3, .length = 0x7190 },
+	{ .name = "b0g0bsinitvals9", .offset = 0x2C8AF8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lcn405initvals35", .offset = 0x2312C0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ac1initvals42", .offset = 0x273218, .type = EXT_IV, .length = 0x1310 },
+	{ .name = "lp0bsinitvals13", .offset = 0x2CC668, .type = EXT_IV, .length = 0x118 },
+	{ .name = "b0g0bsinitvals5", .offset = 0x2C6898, .type = EXT_IV, .length = 0x118 },
+	{ .name = "ucode43", .offset = 0x288270, .type = EXT_UCODE_3, .length = 0x4 },
+	{ .name = "lp0initvals16", .offset = 0x28A3F8, .type = EXT_IV, .length = 0xF90 },
+	{ .name = "lp1bsinitvals20", .offset = 0x28C408, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lcn1initvals25", .offset = 0x2279C8, .type = EXT_IV, .length = 0x10D8 },
+	{ .name = "b0g0initvals13", .offset = 0x2CC788, .type = EXT_IV, .length = 0xBF0 },
+	{ .name = "lcn402initvals33", .offset = 0x231270, .type = EXT_IV, .length = 0x0 },
+	{ .name = "sslpn3bsinitvals21", .offset = 0x28D2B0, .type = EXT_IV, .length = 0x118 },
+	{ .name = "ht0initvals29", .offset = 0x22F198, .type = EXT_IV, .length = 0xF98 },
+	{ .name = "n2bsinitvals19", .offset = 0x28C3B8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "sslpn1bsinitvals20", .offset = 0x28C3F8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ucode25_lcn", .offset = 0x24B570, .type = EXT_UCODE_3, .length = 0x8657 },
+	{ .name = "lcn0initvals24", .offset = 0x221FA8, .type = EXT_IV, .length = 0x10E0 },
+	{ .name = "lcn404initvals33", .offset = 0x231290, .type = EXT_IV, .length = 0x0 },
+	{ .name = "sslpn1bsinitvals27", .offset = 0x22F190, .type = EXT_IV, .length = 0x0 },
+/*	{ .name = "a0g0bsinitvals4", .offset = 0x2C5E80, .type = EXT_IV, .length = 0x0 }, */
+	{ .name = "lcn404bsinitvals33", .offset = 0x231298, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ucode22_sslpn", .offset = 0x2C5E44, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "lcn1bsinitvals25", .offset = 0x228AA8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lcn406initvals37", .offset = 0x2312E0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ac3initvals43", .offset = 0x274780, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lcn2initvals26", .offset = 0x22D0A8, .type = EXT_IV, .length = 0xF48 },
+/*	{ .name = "b0g0initvals4", .offset = 0x2C5E68, .type = EXT_IV, .length = 0x0 }, */
+	{ .name = "ucode20_sslpn", .offset = 0x2B761C, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "lcn403bsinitvals33", .offset = 0x231288, .type = EXT_IV, .length = 0x0 },
+	{ .name = "a0g0bsinitvals9", .offset = 0x2CA1D8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "n0initvals17", .offset = 0x28B4B0, .type = EXT_IV, .length = 0xDD8 },
+	{ .name = "ht0bsinitvals29", .offset = 0x230138, .type = EXT_IV, .length = 0x118 },
+	{ .name = "ucode21_sslpn", .offset = 0x2B762C, .type = EXT_UCODE_3, .length = 0x7405 },
+	{ .name = "sslpn1initvals20", .offset = 0x28C3F0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "sslpn0initvals16", .offset = 0x289340, .type = EXT_IV, .length = 0xF90 },
+	{ .name = "lcn0initvals26", .offset = 0x22AFC8, .type = EXT_IV, .length = 0xF48 },
+	{ .name = "ucode27_sslpn", .offset = 0x25D6E0, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "ucode29_mimo", .offset = 0x25D6E8, .type = EXT_UCODE_3, .length = 0xA8D0 },
+	{ .name = "ucode21_sslpn_nobt", .offset = 0x2BEA38, .type = EXT_UCODE_3, .length = 0x7405 },
+	{ .name = "lp0initvals15", .offset = 0x2CE1C8, .type = EXT_IV, .length = 0xE68 },
+	{ .name = "ucode19_sslpn", .offset = 0x2B760C, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "lcn1bsinitvals24", .offset = 0x224298, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lcn401bsinitvals33", .offset = 0x231268, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lp0bsinitvals14", .offset = 0x2CE1C0, .type = EXT_IV, .length = 0x0 },
+/*	{ .name = "b0g0bsinitvals4", .offset = 0x2C5E70, .type = EXT_IV, .length = 0x0 }, */
+	{ .name = "ucode16_sslpn_nobt", .offset = 0x29DF44, .type = EXT_UCODE_3, .length = 0x701C },
+	{ .name = "n16bsinitvals30", .offset = 0x231120, .type = EXT_IV, .length = 0x118 },
+	{ .name = "a0g1bsinitvals13", .offset = 0x2CE098, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lcn402bsinitvals33", .offset = 0x231278, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ucode19_sslpn_nobt", .offset = 0x2B7614, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "ucode40", .offset = 0x274790, .type = EXT_UCODE_3, .length = 0x9E80 },
+	{ .name = "lcn1initvals24", .offset = 0x2231B0, .type = EXT_IV, .length = 0x10E0 },
+	{ .name = "sslpn2initvals19", .offset = 0x28C3C0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ac2initvals41", .offset = 0x273208, .type = EXT_IV, .length = 0x0 },
+	{ .name = "n16initvals30", .offset = 0x230258, .type = EXT_IV, .length = 0xEC0 },
+	{ .name = "ucode16_lp", .offset = 0x28D400, .type = EXT_UCODE_3, .length = 0x83E8 },
+	{ .name = "n0initvals22", .offset = 0x28D3D0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "sslpn3initvals21", .offset = 0x28C410, .type = EXT_IV, .length = 0xE98 },
+	{ .name = "lp1initvals22", .offset = 0x28D3F0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ac2bsinitvals41", .offset = 0x273210, .type = EXT_IV, .length = 0x0 },
+	{ .name = "a0g1bsinitvals9", .offset = 0x2CA2F8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "n0bsinitvals11", .offset = 0x2CB030, .type = EXT_IV, .length = 0x118 },
+	{ .name = "a0g1bsinitvals5", .offset = 0x2C7EF8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lcn2bsinitvals26", .offset = 0x22DFF8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "ucode34_mimo", .offset = 0x271C58, .type = EXT_UCODE_3, .length = 0x4 },
+	{ .name = "n1initvals20", .offset = 0x28C3E0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lcn2initvals25", .offset = 0x228BC8, .type = EXT_IV, .length = 0x10D8 },
+	{ .name = "ucode37_lcn40", .offset = 0x271C70, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "n0initvals16", .offset = 0x288288, .type = EXT_IV, .length = 0xF90 },
+	{ .name = "n0bsinitvals24", .offset = 0x2266A8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "n1bsinitvals20", .offset = 0x28C3E8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "b0g0initvals5", .offset = 0x2C5E88, .type = EXT_IV, .length = 0xA08 },
+	{ .name = "b0g0initvals9", .offset = 0x2C8018, .type = EXT_IV, .length = 0xAD8 },
+	{ .name = "lcn0bsinitvals24", .offset = 0x223090, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lcn2bsinitvals25", .offset = 0x229CA8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "sslpn4bsinitvals22", .offset = 0x28D3E8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ucode11", .offset = 0x2DA198, .type = EXT_UCODE_2, .length = 0x7818 },
+	{ .name = "n2initvals19", .offset = 0x28C3B0, .type = EXT_IV, .length = 0x0 },
+/*	{ .name = "a0g0initvals4", .offset = 0x2C5E78, .type = EXT_IV, .length = 0x0 }, */
+	{ .name = "pcm4", .offset = 0x2EF834, .type = EXT_PCM, .length = 0x4 },
+	{ .name = "ucode13", .offset = 0x2E19B4, .type = EXT_UCODE_2, .length = 0x6CE0 },
+	{ .name = "lcn0initvals25", .offset = 0x2267C8, .type = EXT_IV, .length = 0x10D8 },
+	{ .name = "sslpn1initvals27", .offset = 0x22F188, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lp0bsinitvals15", .offset = 0x2CF038, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lp0initvals14", .offset = 0x2CE1B8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lp1bsinitvals22", .offset = 0x28D3F8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "n18initvals32", .offset = 0x231240, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lcn405bsinitvals35", .offset = 0x2312C8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ucode41", .offset = 0x27E614, .type = EXT_UCODE_3, .length = 0x4 },
+	{ .name = "lcn400initvals33", .offset = 0x231250, .type = EXT_IV, .length = 0x0 },
+	{ .name = "sslpn0bsinitvals16", .offset = 0x28A2D8, .type = EXT_IV, .length = 0x118 },
+	/* ucode minor version at offset 0x2c5e64 */
+	{ .name = "lcn401initvals33", .offset = 0x231260, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ucode33_lcn40", .offset = 0x271C50, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "a0g1initvals9", .offset = 0x2C96F8, .type = EXT_IV, .length = 0xAD8 },
+	{ .name = "ucode32_mimo", .offset = 0x271C48, .type = EXT_UCODE_3, .length = 0x4 },
+	{ .name = "lcn400bsinitvals33", .offset = 0x231258, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lcn404bsinitvals35", .offset = 0x2312B8, .type = EXT_IV, .length = 0x0 },
+	/* ucode major version at offset 0x221fa0 */
+	{ .name = "n19initvals34", .offset = 0x2312A0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ac3bsinitvals43", .offset = 0x274788, .type = EXT_IV, .length = 0x0 },
+	{ .name = "n0initvals25", .offset = 0x229DC8, .type = EXT_IV, .length = 0x10D8 },
+	{ .name = "ucode26_mimo", .offset = 0x253BCC, .type = EXT_UCODE_3, .length = 0x9B10 },
+	{ .name = "n0bsinitvals16", .offset = 0x289220, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lcn404initvals35", .offset = 0x2312B0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lp2bsinitvals19", .offset = 0x28C3D8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "n19bsinitvals34", .offset = 0x2312A8, .type = EXT_IV, .length = 0x0 },
+/*	{ .name = "ucode4", .offset = 0x2CF158, .type = EXT_UCODE_1, .length = 0x4 }, */
+	{ .name = "ucode20_sslpn_nobt", .offset = 0x2B7624, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "ac0bsinitvals40", .offset = 0x272FB8, .type = EXT_IV, .length = 0x248 },
+	/* ucode minor version at offset 0x271c84 */
+	{ .name = "lcn2initvals24", .offset = 0x2243B8, .type = EXT_IV, .length = 0x10E0 },
+	{ .name = "sslpn4initvals22", .offset = 0x28D3E0, .type = EXT_IV, .length = 0x0 },
+	/* ucode major version at offset 0x288280 */
+	{ .name = "sslpn2bsinitvals19", .offset = 0x28C3C8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "n0bsinitvals25", .offset = 0x22AEA8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lp2initvals19", .offset = 0x28C3D0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "n18bsinitvals32", .offset = 0x231248, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lcn0bsinitvals25", .offset = 0x2278A8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "n0initvals11", .offset = 0x2CA418, .type = EXT_IV, .length = 0xC10 },
+	{ .name = "lcn2bsinitvals24", .offset = 0x2254A0, .type = EXT_IV, .length = 0x118 },
+	/* ucode major version at offset 0x2c5e60 */
+	{ .name = "n0absinitvals11", .offset = 0x2CB150, .type = EXT_IV, .length = 0x118 },
+	{ .name = "a0g0initvals5", .offset = 0x2C69B8, .type = EXT_IV, .length = 0xA08 },
+	{ .name = "a0g1initvals13", .offset = 0x2CD4A0, .type = EXT_IV, .length = 0xBF0 },
+	{ .name = "pcm5", .offset = 0x2EF83C, .type = EXT_PCM, .length = 0x520 },
+	{ .name = "ucode35_lcn40", .offset = 0x271C60, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "ucode14", .offset = 0x2E8698, .type = EXT_UCODE_2, .length = 0x4 },
+	{ .name = "ucode36_mimo", .offset = 0x271C68, .type = EXT_UCODE_3, .length = 0x4 },
+	{ .name = "a0g0initvals9", .offset = 0x2C8C18, .type = EXT_IV, .length = 0xAD8 },
+	{ .name = "ucode17_mimo", .offset = 0x2AE928, .type = EXT_UCODE_3, .length = 0x8CE0 },
+	{ .name = "lp0initvals13", .offset = 0x2CB270, .type = EXT_IV, .length = 0x13F0 },
+	{ .name = "ucode25_mimo", .offset = 0x243844, .type = EXT_UCODE_3, .length = 0x7D28 },
+	{ .name = "lp0bsinitvals16", .offset = 0x28B390, .type = EXT_IV, .length = 0x118 },
+	{ .name = "lcn406bsinitvals37", .offset = 0x2312E8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ac0initvals40", .offset = 0x271C88, .type = EXT_IV, .length = 0x1328 },
+	{ .name = "ucode30_mimo", .offset = 0x267FBC, .type = EXT_UCODE_3, .length = 0x9C88 },
+	{ .name = "b0g0bsinitvals13", .offset = 0x2CD380, .type = EXT_IV, .length = 0x118 },
+	{ .name = "n20bsinitvals36", .offset = 0x2312D8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ucode42", .offset = 0x27E61C, .type = EXT_UCODE_3, .length = 0x9C50 },
+	{ .name = "lcn407initvals38", .offset = 0x2312F0, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lcn1initvals26", .offset = 0x22C038, .type = EXT_IV, .length = 0xF48 },
+	/* ucode major version at offset 0x271c80 */
+	{ .name = "ht0initvals26", .offset = 0x22E118, .type = EXT_IV, .length = 0xF48 },
+	{ .name = "ucode38_lcn40", .offset = 0x271C78, .type = EXT_UCODE_3, .length = 0x1 },
+	{ .name = "lcn407bsinitvals38", .offset = 0x2312F8, .type = EXT_IV, .length = 0x0 },
+	{ .name = "lcn403initvals33", .offset = 0x231280, .type = EXT_IV, .length = 0x0 },
+	{ .name = "ucode16_sslpn", .offset = 0x2957EC, .type = EXT_UCODE_3, .length = 0x8753 },
+	{ .name = "ucode16_mimo", .offset = 0x2A4F64, .type = EXT_UCODE_3, .length = 0x99C0 },
+	/* ucode minor version at offset 0x221fa4 */
+	{ .name = "n0bsinitvals17", .offset = 0x28C290, .type = EXT_IV, .length = 0x118 },
+	{ .name = "a0g1initvals5", .offset = 0x2C73C8, .type = EXT_IV, .length = 0xA08 },
+	{ .name = "n0initvals24", .offset = 0x2255C0, .type = EXT_IV, .length = 0x10E0 },
+	{ .name = "lp1initvals20", .offset = 0x28C400, .type = EXT_IV, .length = 0x0 },
+	{ .name = "a0g0bsinitvals5", .offset = 0x2C7DD8, .type = EXT_IV, .length = 0x118 },
+	{ .name = "ucode9", .offset = 0x2D4394, .type = EXT_UCODE_2, .length = 0x5E00 },
+	{ .name = "ucode5", .offset = 0x2CF160, .type = EXT_UCODE_2, .length = 0x5230 },
+	{ .name = "ucode22_mimo", .offset = 0x2C5E4C, .type = EXT_UCODE_3, .length = 0x4 },
+	EXTRACT_LIST_END
+};
+
 /*
  * Links change, so let's not put them into the README.
  * I still put them here so we know where the file was obtained.
@@ -874,4 +1047,12 @@ static const struct file files[] =
 		.flags		= FW_FLAG_LE | FW_FLAG_V4,
 		.extract	= _e1b05e268bcdbfef3560c28fc161f30e,
 	},
+	{
+		/* http://www.lwfinger.com/b43-firmware/broadcom-wl-6.30.163.46.tar.bz2 */
+		.name		= "wl_apsta.o",
+		.ucode_version	= "784.2",
+		.md5		= "29c8a47094fbae342902d84881a465ff",
+		.flags		= FW_FLAG_LE | FW_FLAG_V4,
+		.extract	= _29c8a47094fbae342902d84881a465ff,
+	},
 };
-- 
1.8.1.4


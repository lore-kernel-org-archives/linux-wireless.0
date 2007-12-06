Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:64911 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbXLFXiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 18:38:09 -0500
Received: by mu-out-0910.google.com with SMTP id i10so70337mue
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2007 15:38:06 -0800 (PST)
Message-ID: <43e72e890712061538k10d806f8xbb7148b0de3f66ce@mail.gmail.com> (sfid-20071206_233816_263038_E7A018D3)
Date: Thu, 6 Dec 2007 18:38:04 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Automated kerneldoc for all wireless drivers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We now have automated kerneldoc HTML output for all Linux wireless
drivers. We just need to the references to our wiki added, and that's
it.

For example ath5k.h wiki entry just has:

<<kerneldoc(ath5k/ath5k.h)>>

This is: http://linuxwireless.org/en/users/Drivers/ath5k/kerneldoc/ath5k.h

The ipw2200 driver though, has:

<<kerneldoc(ipw2200.c)>>

This is: http://linuxwireless.org/en/users/Drivers/ipw2200/kerneldoc/ipw2200.c

Although this uses directories, it really is getting translated to
ath5kath5kh-doc.html to prevent smarty pants from doing stupid things.
Only a few drivers have some content. Please help add their references
and integrate it into the wiki when you can. Below is a line count of
all generated output. In all, 3910 lines of Linux wireless automated
HTML documentation.

     0 adm8211c-doc.html
     0 adm8211h-doc.html
     0 airoc-doc.html
     0 airo_csc-doc.html
     0 airoh-doc.html
     0 airportc-doc.html
     0 arlanh-doc.html
     0 arlan-mainc-doc.html
     0 arlan-procc-doc.html
    32 at76_usbc-doc.html
     0 at76_usbh-doc.html
   167 ath5kath5kh-doc.html
     0 ath5kbasec-doc.html
     0 ath5kbaseh-doc.html
     0 ath5kdebugc-doc.html
    69 ath5kdebugh-doc.html
   174 ath5khwc-doc.html
     0 ath5khwh-doc.html
     0 ath5kinitvalsc-doc.html
    37 ath5kphyc-doc.html
     0 ath5kregdomc-doc.html
     0 ath5kregdomh-doc.html
     0 ath5kregh-doc.html
     0 atmelc-doc.html
     0 atmel_csc-doc.html
     0 atmelh-doc.html
     0 atmel_pcic-doc.html
     0 b43b43h-doc.html
     0 b43debugfsc-doc.html
     0 b43debugfsh-doc.html
     0 b43dmac-doc.html
     0 b43dmah-doc.html
     0 b43ledsc-doc.html
     0 b43ledsh-doc.html
     0 b43legacyb43legacyh-doc.html
     0 b43legacydebugfsc-doc.html
     0 b43legacydebugfsh-doc.html
     0 b43dmac-doc.html
     0 b43dmah-doc.html
     0 b43ledsc-doc.html
     0 b43ledsh-doc.html
     0 b43legacyb43legacyh-doc.html
     0 b43legacydebugfsc-doc.html
     0 b43legacydebugfsh-doc.html
     0 b43legacydmac-doc.html
     0 b43legacydmah-doc.html
     0 b43legacyiltc-doc.html
     0 b43legacyilth-doc.html
     0 b43legacyledsc-doc.html
     0 b43legacyledsh-doc.html
     0 b43legacymainc-doc.html
     0 b43legacymainh-doc.html
     0 b43legacyphyc-doc.html
     0 b43legacyphyh-doc.html
     0 b43legacypioc-doc.html
     0 b43legacypioh-doc.html
     0 b43legacyradioc-doc.html
     0 b43legacyradioh-doc.html
     0 b43legacyrfkillc-doc.html
     0 b43legacyrfkillh-doc.html
     0 b43legacysysfsc-doc.html
     0 b43legacysysfsh-doc.html
     0 b43legacyxmitc-doc.html
     0 b43legacyxmith-doc.html
     0 b43loc-doc.html
     0 b43loh-doc.html
     0 b43mainc-doc.html
     0 b43mainh-doc.html
     0 b43pcmciac-doc.html
     0 b43pcmciah-doc.html
     0 b43phyc-doc.html
     0 b43phyh-doc.html
     0 b43pioc-doc.html
     0 b43pioh-doc.html
     0 b43rfkillc-doc.html
     0 b43rfkillh-doc.html
     0 b43sysfsc-doc.html
     0 b43sysfsh-doc.html
     0 b43tablesc-doc.html
     0 b43tablesh-doc.html
     0 b43wac-doc.html
     0 b43wah-doc.html
     0 b43xmitc-doc.html
     0 b43xmith-doc.html
    60 cfg80211-doc.html
     0 hermesc-doc.html
     0 hermesh-doc.html
     0 hermes_ridh-doc.html
     0 i82586h-doc.html
     0 i82593h-doc.html
    68 ipw2100c-doc.html
     0 ipw2100h-doc.html
   186 ipw2200c-doc.html
     0 ipw2200h-doc.html
     0 libertas11dc-doc.html
     0 libertas11dh-doc.html
     0 libertasadm8211c-doc.html
     0 libertasadm8211h-doc.html
     0 libertasairoc-doc.html
     0 libertasairo_csc-doc.html
     0 libertasairoh-doc.html
     0 libertasairportc-doc.html
     0 libertasarlanh-doc.html
     0 libertasarlan-mainc-doc.html
     0 libertasarlan-procc-doc.html
     0 libertasassocc-doc.html
     0 libertasassoch-doc.html
    32 libertasat76_usbc-doc.html
     0 libertasat76_usbh-doc.html
     0 libertasatmelc-doc.html
     0 libertasatmel_csc-doc.html
     0 libertasatmelh-doc.html
     0 libertasatmel_pcic-doc.html
    25 libertascmdc-doc.html
    12 libertascmdrespc-doc.html
     0 libertasdebugfsc-doc.html
     0 libertasdebugfsh-doc.html
     0 libertasdeclh-doc.html
     0 libertasdefsh-doc.html
     0 libertasdevh-doc.html
     0 libertasethtoolc-doc.html
     0 libertashermesc-doc.html
     0 libertashermesh-doc.html
     0 libertashermes_ridh-doc.html
     0 libertashostcmdh-doc.html
     0 libertashosth-doc.html
     0 libertasi82586h-doc.html
     0 libertasi82593h-doc.html
     0 libertasif_csc-doc.html
     0 libertasif_sdioc-doc.html
     0 libertasif_sdioh-doc.html
     0 libertasif_usbc-doc.html
     0 libertasif_usbh-doc.html
    68 libertasipw2100c-doc.html
     0 libertasipw2100h-doc.html
   186 libertasipw2200c-doc.html
     0 libertasipw2200h-doc.html
    14 libertasjoinc-doc.html
     0 libertasjoinh-doc.html
    73 libertasmainc-doc.html
     0 libertasnet2280h-doc.html
     0 libertasnetwave_csc-doc.html
     0 libertasorinococ-doc.html
     0 libertasorinoco_csc-doc.html
     0 libertasorinocoh-doc.html
     0 libertasorinoco_nortelc-doc.html
     0 libertasorinoco_pcic-doc.html
     0 libertasorinoco_pcih-doc.html
     0 libertasorinoco_plxc-doc.html
     0 libertasorinoco_tmdc-doc.html
     0 libertasp54commonc-doc.html
     0 libertasp54commonh-doc.html
     0 libertasp54h-doc.html
     0 libertasp54pcic-doc.html
     0 libertasp54pcih-doc.html
     0 libertasp54usbc-doc.html
     0 libertasp54usbh-doc.html
     0 libertasradiotaph-doc.html
     0 libertasray_csc-doc.html
     0 libertasray_csh-doc.html
     0 libertasrayctlh-doc.html
     0 libertasrtl8180_devc-doc.html
     0 libertasrtl8180h-doc.html
     0 libertasrtl8180_max2820c-doc.html
     0 libertasrtl8180_max2820h-doc.html
     0 libertasrtl8180_rtl8225c-doc.html
     0 libertasrtl8180_rtl8225h-doc.html
     0 libertasrtl8180_sa2400c-doc.html
     0 libertasrtl8180_sa2400h-doc.html
     0 libertasrtl8187_devc-doc.html
     0 libertasrtl8187h-doc.html
     0 libertasrtl8187_rtl8225c-doc.html
     0 libertasrtl8187_rtl8225h-doc.html
     0 libertasrtl818xh-doc.html
     0 libertasrxc-doc.html
     0 libertasscanc-doc.html
     0 libertasscanh-doc.html
     0 libertasspectrum_csc-doc.html
     0 libertasstripc-doc.html
     8 libertastxc-doc.html
     0 libertastypesh-doc.html
     0 libertaswavelanc-doc.html
     0 libertaswavelan_csc-doc.html
     0 libertaswavelan_csh-doc.html
     0 libertaswavelan_cs.ph-doc.html
     0 libertaswavelanh-doc.html
     0 libertaswavelan.ph-doc.html
     8 libertaswextc-doc.html
     0 libertaswexth-doc.html
   254 libertaswl3501_csc-doc.html
     0 libertaswl3501h-doc.html
     0 libertaszd1201c-doc.html
     0 libertaszd1201h-doc.html
  1621 mac80211-doc.html
     0 net2280h-doc.html
     0 netwave_csc-doc.html
   135 nl80211-doc.html
     0 orinococ-doc.html
     0 orinoco_csc-doc.html
     0 orinocoh-doc.html
     0 orinoco_nortelc-doc.html
     0 orinoco_pcic-doc.html
     0 orinoco_pcih-doc.html
     0 orinoco_plxc-doc.html
     0 orinoco_tmdc-doc.html
     0 p54commonc-doc.html
     0 p54commonh-doc.html
     0 p54h-doc.html
     0 p54pcic-doc.html
     0 p54pcih-doc.html
     0 p54usbc-doc.html
     0 p54usbh-doc.html
     0 ray_csc-doc.html
     0 ray_csh-doc.html
     0 rayctlh-doc.html
     0 rt2x00rt2400pcic-doc.html
     0 rt2x00rt2400pcih-doc.html
     0 rt2x00rt2500pcic-doc.html
     0 rt2x00rt2500pcih-doc.html
     0 rt2x00rt2500usbc-doc.html
     0 rt2x00rt2500usbh-doc.html
     0 rt2x00rt2x00configc-doc.html
     0 rt2x00rt2x00debugc-doc.html
     0 rt2x00rt2x00debugh-doc.html
     0 rt2x00rt2x00devc-doc.html
   104 rt2x00rt2x00dumph-doc.html
     0 rt2x00rt2x00firmwarec-doc.html
     0 rt2x00rt2x00h-doc.html
     0 rt2x00rt2x00libh-doc.html
     0 rt2x00rt2x00macc-doc.html
     0 rt2x00rt2x00pcic-doc.html
     0 rt2x00rt2x00pcih-doc.html
     0 rt2x00rt2x00regh-doc.html
     0 rt2x00rt2x00rfkillc-doc.html
     0 rt2x00rt2x00ringh-doc.html
     0 rt2x00rt2x00usbc-doc.html
     0 rt2x00rt2x00usbh-doc.html
     0 rt2x00rt61pcic-doc.html
     0 rt2x00rt61pcih-doc.html
     0 rt2x00rt73usbc-doc.html
     0 rt2x00rt73usbh-doc.html
     0 rtl8180_devc-doc.html
     0 rtl8180h-doc.html
     0 rtl8180_max2820c-doc.html
     0 rtl8180_max2820h-doc.html
     0 rtl8180_rtl8225c-doc.html
     0 rtl8180_rtl8225h-doc.html
     0 rtl8180_sa2400c-doc.html
     0 rtl8180_sa2400h-doc.html
     0 rtl8187_devc-doc.html
     0 rtl8187h-doc.html
     0 rtl8187_rtl8225c-doc.html
     0 rtl8187_rtl8225h-doc.html
     0 rtl818xh-doc.html
     0 spectrum_csc-doc.html
     0 stripc-doc.html
     0 wavelanc-doc.html
     0 wavelan_csc-doc.html
     0 wavelan_csh-doc.html
     0 wavelan_cs.ph-doc.html
     0 wavelanh-doc.html
     0 wavelan.ph-doc.html
   254 wl3501_csc-doc.html
     0 wl3501h-doc.html
     0 zd1201c-doc.html
     0 zd1201h-doc.html
    17 zd1211rwzd_chipc-doc.html
     0 zd1211rwzd_chiph-doc.html
     0 zd1211rwzd_defh-doc.html
     0 zd1211rwzd_ieee80211c-doc.html
     0 zd1211rwzd_ieee80211h-doc.html
   157 zd1211rwzd_macc-doc.html
    20 zd1211rwzd_mach-doc.html
     0 zd1211rwzd_rf_al2230c-doc.html
     0 zd1211rwzd_rf_al7230bc-doc.html
     0 zd1211rwzd_rfc-doc.html
     0 zd1211rwzd_rfh-doc.html
     0 zd1211rwzd_rf_rf2959c-doc.html
     0 zd1211rwzd_rf_uw2453c-doc.html
   106 zd1211rwzd_usbc-doc.html
    23 zd1211rwzd_usbh-doc.html
  3910 total

  Luis

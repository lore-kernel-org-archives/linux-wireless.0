Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34168 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZEGNEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 09:04:12 -0400
Received: by fxm2 with SMTP id 2so769313fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 07 May 2009 06:04:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <81c556230905061857o52b1ad36v9668c3b7e0da6b76@mail.gmail.com>
References: <81c556230905061857o52b1ad36v9668c3b7e0da6b76@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 7 May 2009 15:03:51 +0200
Message-ID: <69e28c910905070603i4b421829x7563b667f20b7f83@mail.gmail.com>
Subject: Re:
To: waqas <waqas281@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 7, 2009 at 3:57 AM, waqas <waqas281@gmail.com> wrote:
> root@bt:~/Desktop/compat-wireless-2009-05-06# make install
>
> Your old wireless subsystem modules were left intact:
>
> /lib/modules/2.6.28.1/kernel/net/mac80211/mac80211.ko
> /lib/modules/2.6.28.1/kernel/net/wireless/cfg80211.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/adm8211.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/ath5k/ath5k.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/ath9k/ath9k.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/b43/b43.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/b43legacy/b43legacy=
=2Eko
> /lib/modules/2.6.28.1/kernel/drivers/net/usb/cdc_ether.ko
> /lib/modules/2.6.28.1/kernel/drivers/misc/eeprom_93cx6.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/ipw2100.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/ipw2200.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/iwlwifi/iwl3945.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/libertas/libertas.k=
o
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/libertas/libertas_c=
s.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/libertas/libertas_s=
dio.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/libertas_tf/liberta=
s_tf.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/libertas_tf/liberta=
s_tf_usb.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/mac80211_hwsim.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/p54/p54common.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/p54/p54pci.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/p54/p54usb.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/usb/rndis_host.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rndis_wlan.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rt2x00/rt2400pci.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rt2x00/rt2500pci.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rt2x00/rt2500usb.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rt2x00/rt2x00pci.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rt2x00/rt2x00usb.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rt2x00/rt61pci.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rt2x00/rt73usb.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rtl8180.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/rtl8187.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/libertas/usb8xxx.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/usb/usbnet.ko
> /lib/modules/2.6.28.1/kernel/drivers/net/wireless/zd1211rw/zd1211rw.k=
o
>
> make -C /lib/modules/2.6.28.1/build
> M=3D/root/Desktop/compat-wireless-2009-05-06 "INSTALL_MOD_DIR=3Dupdat=
es"
> \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0modules_install
> make[1]: Entering directory `/usr/src/linux-source-2.6.28.1'
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/misc/eepr=
om/eeprom_93cx6.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/b44.k=
o
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/usb/c=
dc_ether.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/usb/r=
ndis_host.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/usb/u=
sbnet.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/adm8211.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/at76c50x-usb.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/ath/ath.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/ath/ath5k/ath5k.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/ath/ath9k/ath9k.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/b43/b43.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/b43legacy/b43legacy.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/ipw2x00/ipw2100.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/ipw2x00/ipw2200.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/ipw2x00/libipw.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/iwlwifi/iwl3945.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/iwlwifi/iwlagn.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/iwlwifi/iwlcore.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/libertas/libertas.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/libertas/libertas_cs.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/libertas/libertas_sdio.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/libertas/usb8xxx.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/libertas_tf/libertas_tf.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/libertas_tf/libertas_tf_usb.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/mac80211_hwsim.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/mwl8k.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/p54/p54common.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/p54/p54pci.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/p54/p54usb.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rndis_wlan.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rt2x00/rt2400pci.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rt2x00/rt2500pci.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rt2x00/rt2500usb.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rt2x00/rt2800usb.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rt2x00/rt2x00lib.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rt2x00/rt2x00pci.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rt2x00/rt2x00usb.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rt2x00/rt61pci.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rt2x00/rt73usb.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rtl818x/rtl8180.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/rtl818x/rtl8187.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/drivers/net/wirel=
ess/zd1211rw/zd1211rw.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/net/mac80211/mac8=
0211.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/net/wireless/cfg8=
0211.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/net/wireless/lib8=
0211.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/net/wireless/lib8=
0211_crypt_ccmp.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/net/wireless/lib8=
0211_crypt_tkip.ko
> =A0INSTALL /root/Desktop/compat-wireless-2009-05-06/net/wireless/lib8=
0211_crypt_wep.ko
> =A0DEPMOD =A02.6.28.1
> make[1]: Leaving directory `/usr/src/linux-source-2.6.28.1'
>
> Note: madwifi detected, we're going to disable it. If you would like
> to enable it later you can run:
> =A0 =A0sudo athenable madwifi
>
> Running athenable ath5k...
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
> [ERROR] Module is still being detected:
> /lib/modules/2.6.28.1/net/ath_pci.ko
> Disabling ath_pci ...mv: cannot stat
> `/lib/modules/2.6.28.1//lib/modules/2.6.28.1/net/ath_pci.ko': No such
> file or directory
>
>
>
> google search don't show up anything so only thing i can do is send b=
ug report.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Try this patch:

--- scripts/modlib.sh.bak	2009-05-06 22:40:50.000000000 +0200
+++ scripts/modlib.sh	2009-05-06 22:40:31.000000000 +0200
 -38,7 +38,7 @@ function module_disable {
 		else
 			echo -en "Disabling $MODULE ..."
 		fi
-		mv -f /lib/modules/$VER/$CHECK /lib/modules/$VER/${CHECK}${IGNORE_SU=
=46FIX}
+		mv -f $CHECK ${CHECK}${IGNORE_SUFFIX}
 		depmod -ae
 		CHECK_AGAIN=3D`modprobe -l $MODULE`
 		if [ "$CHECK" !=3D "$CHECK_AGAIN" ]; then

(pastebin address if this mail is linewrapped: http://pastebin.com/f233=
42312)

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

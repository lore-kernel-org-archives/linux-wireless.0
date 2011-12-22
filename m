Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62151 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1LVH5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 02:57:41 -0500
Received: by qadc12 with SMTP id c12so4194729qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 23:57:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG9cJmmnEsLQxxbi41v6nM8D+L_cOSQE73qJmDDYhXPnopn+MA@mail.gmail.com>
References: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
	<4EF21983.1020107@broadcom.com>
	<CACna6rxEjQLj_j-f7WZOtOEGfDa+TPWyLDrn2t-FGZ5T2_fz-g@mail.gmail.com>
	<CAG9cJm=XE3jQiYvGB4T6_Avj=bmc_wXe8JGMr5hePuCu-OnPuA@mail.gmail.com>
	<CACna6rxvmFptSR9WF8Whj1A0ATyygQ9Eo0nUY8n6MugQ0bjP7g@mail.gmail.com>
	<CAG9cJmmnEsLQxxbi41v6nM8D+L_cOSQE73qJmDDYhXPnopn+MA@mail.gmail.com>
Date: Thu, 22 Dec 2011 15:57:40 +0800
Message-ID: <CAG9cJmmHhCB4S3YPJAjnRRF1kJPAj9Nw8kAZEM3RtqzO89sOiQ@mail.gmail.com> (sfid-20111222_085820_032295_4CA7979A)
Subject: Re: bcm4331 firmware installer package
From: lina <lina.lastname@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Debian Lists <debian-user@lists.debian.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here I posted the log of installation of compate-wireless.

(sorry, I am not confident doing this (first time and so many
unfamiliar terms), so welcome detailed suggestions).

Thanks,

Note: iwl4965 detected, we're going to disable it. If you would like
to enable it later you can run:
    sudo iwl-load iwl4965

Running iwl-enable iwlagn...
2 iwl4965 modules found we'll disable all of them
Disabling iwl4965 (1) ...WARNING: -e needs -E or -F
[ERROR]	Module is still being detected:
updates/drivers/net/wireless/iwlegacy/iwl4965.ko
Disabling iwl4965 (2) ...WARNING: -e needs -E or -F
	[OK]	Module disabled:
updates/drivers/net/wireless/iwlegacy/iwl4965.ko
depmod will prefer updates/ over kernel/ -- OK!

Currently detected wireless subsystem modules:

updates/net/mac80211/mac80211.ko
updates/net/wireless/cfg80211.ko
updates/net/wireless/lib80211.ko
updates/drivers/net/wireless/adm8211.ko
updates/drivers/net/wireless/at76c50x-usb.ko
updates/drivers/net/wireless/ath/ath.ko
updates/drivers/net/wireless/ath/ath5k/ath5k.ko
updates/drivers/net/wireless/ath/ath6kl/ath6kl.ko
updates/drivers/net/wireless/ath/ath9k/ath9k.ko
updates/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
updates/drivers/net/wireless/b43/b43.ko
updates/drivers/net/wireless/b43legacy/b43legacy.ko
updates/drivers/net/ethernet/broadcom/b44.ko
updates/drivers/net/wireless/ath/carl9170/carl9170.ko
updates/drivers/net/usb/cdc_ether.ko
updates/drivers/misc/eeprom/eeprom_93cx6.ko
updates/drivers/net/wireless/ipw2x00/ipw2100.ko
updates/drivers/net/wireless/ipw2x00/ipw2200.ko
updates/drivers/net/wireless/iwlegacy/iwl3945.ko
updates/drivers/net/wireless/iwmc3200wifi/iwmc3200wifi.ko
updates/net/wireless/lib80211_crypt_ccmp.ko
updates/net/wireless/lib80211_crypt_tkip.ko
updates/net/wireless/lib80211_crypt_wep.ko
updates/drivers/net/wireless/libertas/libertas.ko
updates/drivers/net/wireless/libertas/libertas_cs.ko
updates/drivers/net/wireless/libertas/libertas_sdio.ko
updates/drivers/net/wireless/libertas/libertas_spi.ko
updates/drivers/net/wireless/libertas_tf/libertas_tf.ko
updates/drivers/net/wireless/libertas_tf/libertas_tf_usb.ko
updates/drivers/net/wireless/ipw2x00/libipw.ko
updates/drivers/net/wireless/mac80211_hwsim.ko
updates/drivers/net/wireless/mwl8k.ko
updates/drivers/net/wireless/orinoco/orinoco_cs.ko
updates/drivers/net/wireless/orinoco/orinoco_nortel.ko
updates/drivers/net/wireless/orinoco/orinoco_pci.ko
updates/drivers/net/wireless/orinoco/orinoco_plx.ko
updates/drivers/net/wireless/orinoco/orinoco_usb.ko
updates/drivers/net/wireless/orinoco/orinoco.ko
updates/drivers/net/wireless/p54/p54common.ko
updates/drivers/net/wireless/p54/p54pci.ko
updates/drivers/net/wireless/p54/p54spi.ko
updates/drivers/net/wireless/p54/p54usb.ko
updates/drivers/net/usb/rndis_host.ko
updates/drivers/net/wireless/rndis_wlan.ko
updates/drivers/net/wireless/rt2x00/rt2400pci.ko
updates/drivers/net/wireless/rt2x00/rt2500pci.ko
updates/drivers/net/wireless/rt2x00/rt2500usb.ko
updates/drivers/net/wireless/rt2x00/rt2800pci.ko
updates/drivers/net/wireless/rt2x00/rt2800usb.ko
updates/drivers/net/wireless/rt2x00/rt2x00lib.ko
updates/drivers/net/wireless/rt2x00/rt2x00pci.ko
updates/drivers/net/wireless/rt2x00/rt2x00usb.ko
updates/drivers/net/wireless/rt2x00/rt61pci.ko
updates/drivers/net/wireless/rt2x00/rt73usb.ko
updates/drivers/net/wireless/rtl818x/rtl8180/rtl8180.ko
updates/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
updates/drivers/net/wireless/rtlwifi/rtlwifi.ko
updates/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko
updates/drivers/net/wireless/orinoco/spectrum_cs.ko
updates/drivers/ssb/ssb.ko
updates/drivers/net/wireless/libertas/usb8xxx.ko
updates/drivers/net/usb/usbnet.ko
updates/drivers/net/wireless/wl1251/wl1251.ko
updates/drivers/net/wireless/wl12xx/wl12xx.ko
updates/drivers/net/wireless/zd1211rw/zd1211rw.ko

Currently detected ethernet subsystem modules:

updates/drivers/net/ethernet/atheros/atlx/atl1.ko
updates/drivers/net/ethernet/atheros/atlx/atl2.ko
updates/drivers/net/ethernet/atheros/atl1e/atl1e.ko
updates/drivers/net/ethernet/atheros/atl1c/atl1c.ko

Currently detected bluetooth subsystem modules:

updates/drivers/bluetooth/ath3k.ko
updates/drivers/bluetooth/bcm203x.ko
updates/drivers/bluetooth/bluecard_cs.ko
updates/net/bluetooth/bluetooth.ko
updates/net/bluetooth/bnep/bnep.ko
updates/drivers/bluetooth/bpa10x.ko
updates/drivers/bluetooth/bt3c_cs.ko
updates/drivers/bluetooth/btmrvl.ko
updates/drivers/bluetooth/btmrvl_sdio.ko
updates/drivers/bluetooth/btsdio.ko
updates/drivers/bluetooth/btusb.ko
updates/drivers/bluetooth/btuart_cs.ko
updates/net/bluetooth/cmtp/cmtp.ko
updates/drivers/bluetooth/dtl1_cs.ko
updates/net/bluetooth/hidp/hidp.ko
updates/drivers/bluetooth/hci_vhci.ko
updates/drivers/bluetooth/hci_uart.ko
updates/net/bluetooth/rfcomm/rfcomm.ko

Now run:

sudo make unload to unload all: wireless, bluetooth and ethernet modules
sudo make wlunload to unload wireless modules
sudo make btunload to unload bluetooth modules

Run sudo modprobe driver-name to load your desired driver.
If unsure reboot.

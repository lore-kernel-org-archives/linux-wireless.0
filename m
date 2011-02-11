Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36103.mail.mud.yahoo.com ([66.163.179.217]:47142 "HELO
	web36103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751546Ab1BKBPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 20:15:00 -0500
Message-ID: <370529.47352.qm@web36103.mail.mud.yahoo.com>
References: <875258.44241.qm@web36104.mail.mud.yahoo.com> <971463.73333.qm@web36106.mail.mud.yahoo.com> <AANLkTimbnJG5WkdRZvAoZZ_isnrMUDicnw_B24SP7EKF@mail.gmail.com>
Date: Thu, 10 Feb 2011 17:14:59 -0800 (PST)
From: Noel Milton Vega <nmvega@nyceyes.com>
Reply-To: Noel Milton Vega <nmvega@nyceyes.com>
Subject: Re: compat-wireless trial :: Need Linux driver (preferably 64 bit) for "Intel Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: Julian Calaby <julian.calaby@gmail.com>
Cc: ozan@pardus.org.tr, linux-wireless@vger.kernel.org,
	Noel Milton Vega <nmvega@ComputingArchitects.Com>
In-Reply-To: <AANLkTimbnJG5WkdRZvAoZZ_isnrMUDicnw_B24SP7EKF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-484645885-1297386899=:47352"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0-484645885-1297386899=:47352
Content-Type: text/plain; charset=us-ascii


hello...

FYI...

Trying the latest *stable* version, which if I'm understanding this is
"compat-wireless-2.6.38-rc4-1.tar.bz2", results in no "iwl*.ko" modules
being built on issuing a make(1).

Below is the output of the compile session. I attached the Makefile (hopefully
the list email address doesn't cause a bounce due to attachments).

##########################################################################
root@p170hm# cd compat-wireless-2.6.38-rc4-1
root@p170hm# ./scripts/driver-select iwlwifi
Processing new driver-select request...
Backup exists: Makefile.bk
Backup exists: drivers/net/wireless/Makefile.bk
Backup exists: Makefile.bk
Backup exists: net/wireless/Makefile.bk
Backup exists: drivers/net/Makefile.bk
Backup exists: drivers/ssb/Makefile.bk
Backup exists: drivers/misc/eeprom/Makefile.bk
Backup exists: Makefile.bk
root@p170hm# 
root@p170hm# make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.35.10-74.fc14.x86_64/build 
M=/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1 modules
make[1]: Entering directory `/usr/src/kernels/2.6.35.10-74.fc14.x86_64'
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/main.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/compat-2.6.36.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/compat-2.6.37.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/compat-2.6.38.o
  LD [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/compat.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/kfifo.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_vhci.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btmrvl_main.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btmrvl_debugfs.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_ldisc.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_h4.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_bcsp.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_ll.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_ath.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_uart.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bcm203x.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bpa10x.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bfusb.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/dtl1_cs.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bt3c_cs.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bluecard_cs.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btuart_cs.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btusb.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btsdio.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/ath3k.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btmrvl.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btmrvl_sdio.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1c/atl1c_main.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1c/atl1c_hw.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1c/atl1c_ethtool.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1c/atl1c.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1e/atl1e_main.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1e/atl1e_hw.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1e/atl1e_ethtool.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1e/atl1e_param.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1e/atl1e.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atlx/atl1.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atlx/atl2.o
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atlx/atl2.c:1704:2:
 warning: initialization discards qualifiers from pointer target type
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/af_bluetooth.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hci_core.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hci_conn.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hci_event.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/mgmt.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hci_sock.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hci_sysfs.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/lib.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/bluetooth.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/l2cap.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/sco.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/bnep/core.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/bnep/sock.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/bnep/netdev.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/bnep/bnep.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/cmtp/core.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/cmtp/sock.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/cmtp/capi.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/cmtp/cmtp.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hidp/core.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hidp/sock.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hidp/hidp.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/rfcomm/core.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/rfcomm/sock.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/rfcomm/tty.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/rfcomm/rfcomm.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/main.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/status.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/sta_info.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/wep.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/wpa.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/scan.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/offchannel.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/ht.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/agg-tx.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/agg-rx.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/ibss.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/mlme.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/work.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/iface.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/rate.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/michael.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/tkip.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/aes_ccm.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/aes_cmac.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/cfg.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/rx.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/spectmgmt.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/tx.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/key.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/util.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/wme.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/event.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/chan.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/led.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/debugfs.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/debugfs_sta.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/debugfs_netdev.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/debugfs_key.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/mesh.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/mesh_pathtbl.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/mesh_plink.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/mesh_hwmp.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/pm.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/rc80211_pid_algo.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/rc80211_pid_debugfs.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/rc80211_minstrel.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/rc80211_minstrel_debugfs.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/rc80211_minstrel_ht.o

  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/rc80211_minstrel_ht_debugfs.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/mac80211.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/core.o
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/core.c:7:0: 
warning: "pr_fmt" redefined
include/linux/kernel.h:381:0: note: this is the location of the previous 
definition
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/sysfs.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/radiotap.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/util.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/reg.o
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/reg.c:36:0: 
warning: "pr_fmt" redefined
include/linux/kernel.h:381:0: note: this is the location of the previous 
definition
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/scan.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/nl80211.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/mlme.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/ibss.o
  CC [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/sme.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/chan.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/ethtool.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/mesh.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/debugfs.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/wext-compat.o
  CC [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/wext-sme.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/cfg80211.o
  Building modules, stage 2.
  MODPOST 29 modules
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/compat.mod.o
  LD [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/compat.ko
  CC      /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/kfifo.mod.o
  LD [M]  /home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/compat/kfifo.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/ath3k.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/ath3k.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bcm203x.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bcm203x.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bfusb.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bfusb.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bluecard_cs.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bluecard_cs.ko

  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bpa10x.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bpa10x.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bt3c_cs.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/bt3c_cs.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btmrvl.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btmrvl.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btmrvl_sdio.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btmrvl_sdio.ko

  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btsdio.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btsdio.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btuart_cs.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btuart_cs.ko

  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btusb.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/btusb.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/dtl1_cs.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/dtl1_cs.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_uart.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_uart.ko

  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_vhci.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/bluetooth/hci_vhci.ko

  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1c/atl1c.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1c/atl1c.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1e/atl1e.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atl1e/atl1e.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atlx/atl1.mod.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atlx/atl1.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atlx/atl2.mod.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/drivers/net/atlx/atl2.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/bluetooth.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/bluetooth.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/bnep/bnep.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/bnep/bnep.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/cmtp/cmtp.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/cmtp/cmtp.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hidp/hidp.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/hidp/hidp.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/l2cap.mod.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/l2cap.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/rfcomm/rfcomm.mod.o

  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/rfcomm/rfcomm.ko

  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/sco.mod.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/bluetooth/sco.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/mac80211.mod.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/mac80211/mac80211.ko
  CC      
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/cfg80211.mod.o
  LD [M]  
/home/nmvega/Downloads/compat-wireless-2.6.38-rc4-1/net/wireless/cfg80211.ko
make[1]: Leaving directory `/usr/src/kernels/2.6.35.10-74.fc14.x86_64'

##########################################################################



----- Original Message ----
> From: Julian Calaby <julian.calaby@gmail.com>
> To: Noel Milton Vega <nmvega@nyceyes.com>
> Cc: ozan@pardus.org.tr; linux-wireless@vger.kernel.org
> Sent: Thu, February 10, 2011 7:19:07 PM
> Subject: Re: compat-wireless trial :: Need Linux driver (preferably 64 bit) for 
>"Intel Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
> 
> On Fri, Feb 11, 2011 at 11:05, Noel Milton Vega <nmvega@nyceyes.com> wrote:
> >  Hello:
> >
> > As someone suggested, I tried the stable version of the  compat-wireless 
>solution
> >  (http://wireless.kernel.org/en/users/Download/stable). Because I'm
> >  running FC14 kernel version "2.6.35.10-74.fc14.x86_64", I
> > selected  "compat-wireless-2.6.35-1.tar.bz2" (if that logic is
> > flawed for  selecting a compat version, please let me know. Thanks. Note
> > that I  acknowledge seeing the "Bug" citation near the end of the URL 
above).
> 
> The  version for compat-wireless indicates the version of the wireless
> stack that  it contains, not the version of the kernel it's for.
> 
> You should download  the latest version and try that.
> 
> Thanks,
> 
> -- 
> Julian  Calaby
> 
> Email: julian.calaby@gmail.com
> Profile:  http://www.google.com/profiles/julian.calaby/
> .Plan:  http://sites.google.com/site/juliancalaby/
> 
--0-484645885-1297386899=:47352
Content-Type: application/octet-stream; name=Makefile
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="Makefile"

ZXhwb3J0IEtNT0RESVI/PSAgICAgICB1cGRhdGVzCktNT0RESVJfQVJHOj0g
ICAiSU5TVEFMTF9NT0RfRElSPSQoS01PRERJUikiCmlmbmVxICgkKG9yaWdp
biBLTElCKSwgdW5kZWZpbmVkKQpLTU9EUEFUSF9BUkc6PSAgIklOU1RBTExf
TU9EX1BBVEg9JChLTElCKSIKZWxzZQpleHBvcnQgS0xJQjo9ICAgICAgICAg
IC9saWIvbW9kdWxlcy8kKHNoZWxsIHVuYW1lIC1yKQplbmRpZgpleHBvcnQg
S0xJQl9CVUlMRCA/PQkkKEtMSUIpL2J1aWxkCiMgU29tZXRpbWVzIG5vdCBh
dmFpbGFibGUgaW4gdGhlIHBhdGgKTU9EUFJPQkUgOj0gL3NiaW4vbW9kcHJv
YmUKTUFEV0lGST0kKHNoZWxsICQoTU9EUFJPQkUpIC1sIGF0aF9wY2kpCk9M
RF9JV0w9JChzaGVsbCAkKE1PRFBST0JFKSAtbCBpd2w0OTY1KQoKREVTVERJ
Uj89CgppZm5lcSAoJChLRVJORUxSRUxFQVNFKSwpCgpOT1NURElOQ19GTEFH
UyA6PSAtSSQoTSkvaW5jbHVkZS8gXAoJLWluY2x1ZGUgJChNKS9pbmNsdWRl
L2xpbnV4L2NvbXBhdC0yLjYuaCBcCgkkKENGTEFHUykKCm9iai15IDo9IGNv
bXBhdC8KCm9iai0kKENPTkZJR19DT01QQVRfUkZLSUxMKSArPSBuZXQvcmZr
aWxsLwoKaWZlcSAoJChCVCksKQpvYmotJChDT05GSUdfQ09NUEFUX1dJUkVM
RVNTKSArPSBuZXQvd2lyZWxlc3MvIG5ldC9tYWM4MDIxMS8Kb2JqLSQoQ09O
RklHX0NPTVBBVF9XSVJFTEVTU19NT0RVTEVTKSArPSBkcml2ZXJzL25ldC93
aXJlbGVzcy8KCgpvYmotJChDT05GSUdfQ09NUEFUX05FVFdPUktfTU9EVUxF
UykgKz0gZHJpdmVycy9uZXQvCm9iai0kKENPTkZJR19DT01QQVRfVkFSX01P
RFVMRVMpICs9ICBkcml2ZXJzL3NzYi8gZHJpdmVycy9taXNjL2VlcHJvbS8K
CmlmZXEgKCQoQ09ORklHX1NUQUdJTkdfRVhDTFVERV9CVUlMRCksKQplbmRp
ZgoKZW5kaWYKCm9iai0kKENPTkZJR19DT01QQVRfQkxVRVRPT1RIKSArPSBu
ZXQvYmx1ZXRvb3RoLwpvYmotJChDT05GSUdfQ09NUEFUX0JMVUVUT09USF9N
T0RVTEVTKSArPSBkcml2ZXJzL2JsdWV0b290aC8KCmVsc2UKCmV4cG9ydCBQ
V0QgOj0JJChzaGVsbCBwd2QpCkNGTEFHUyArPSBcCiAgICAgICAgLURDT01Q
QVRfQkFTRV9UUkVFPSJcIiQoc2hlbGwgY2F0IGNvbXBhdF9iYXNlX3RyZWUp
XCIiIFwKICAgICAgICAtRENPTVBBVF9CQVNFX1RSRUVfVkVSU0lPTj0iXCIk
KHNoZWxsIGNhdCBjb21wYXRfYmFzZV90cmVlX3ZlcnNpb24pXCIiIFwKICAg
ICAgICAtRENPTVBBVF9QUk9KRUNUPSJcIkNvbXBhdC13aXJlbGVzc1wiIiBc
CiAgICAgICAgLURDT01QQVRfVkVSU0lPTj0iXCIkKHNoZWxsIGNhdCBjb21w
YXRfdmVyc2lvbilcIiIKCiMgVGhlc2UgZXhwb3J0ZWQgYXMgdGhleSBhcmUg
dXNlZCBieSB0aGUgc2NyaXB0cwojIHRvIGNoZWNrIGNvbmZpZyBhbmQgY29t
cGF0IGF1dG9jb25mCmV4cG9ydCBDT01QQVRfQ09ORklHPWNvbmZpZy5tawpl
eHBvcnQgQ09ORklHX0NIRUNLPS4kKENPTVBBVF9DT05GSUcpX21kNXN1bS50
eHQKZXhwb3J0IENPTVBBVF9BVVRPQ09ORj1pbmNsdWRlL2xpbnV4L2NvbXBh
dF9hdXRvY29uZi5oCmV4cG9ydCBDUkVMPSQoc2hlbGwgY2F0ICQoUFdEKS9j
b21wYXRfdmVyc2lvbikKZXhwb3J0IENSRUxfUFJFOj0uY29tcGF0X2F1dG9j
b25mXwpleHBvcnQgQ1JFTF9DSEVDSzo9JChDUkVMX1BSRSkkKENSRUwpCgpp
bmNsdWRlICQoUFdEKS8kKENPTVBBVF9DT05GSUcpCgphbGw6IG1vZHVsZXMK
Cm1vZHVsZXM6ICQoQ1JFTF9DSEVDSykKCUAuL3NjcmlwdHMvY2hlY2tfY29u
ZmlnLnNoCgkkKE1BS0UpIC1DICQoS0xJQl9CVUlMRCkgTT0kKFBXRCkgbW9k
dWxlcwoJQHRvdWNoICRACgpidDogJChDUkVMX0NIRUNLKQoJQC4vc2NyaXB0
cy9jaGVja19jb25maWcuc2gKCSQoTUFLRSkgLUMgJChLTElCX0JVSUxEKSBN
PSQoUFdEKSBCVD1UUlVFIG1vZHVsZXMKCUB0b3VjaCAkQAoKIyBXaXRoIHRo
ZSBhYm92ZSBhbmQgdGhpcyB3ZSBtYWtlIHN1cmUgd2UgZ2VuZXJhdGUgYSBu
ZXcgY29tcGF0IGF1dG9jb25mIHBlcgojIG5ldyByZWxhc2Ugb2YgY29tcGF0
LXdpcmVsZXNzLTIuNiBPUiB3aGVuIHRoZSB1c2VyIHVwZGF0ZXMgdGhlIAoj
ICQoQ09NUEFUX0NPTkZJRykgZmlsZQokKENSRUxfQ0hFQ0spOgoJQCMgRm9y
Y2UgdG8gcmVnZW5lcmF0ZSBjb21wYXQgYXV0b2NvbmYKCUBybSAtZiAkKENP
TkZJR19DSEVDSykKCUAuL3NjcmlwdHMvY2hlY2tfY29uZmlnLnNoCglAdG91
Y2ggJEAKCUBtZDVzdW0gJChDT01QQVRfQ09ORklHKSA+ICQoQ09ORklHX0NI
RUNLKQoKYnRpbnN0YWxsOiBidHVuaW5zdGFsbCBidC1pbnN0YWxsLW1vZHVs
ZXMKCmJ0LWluc3RhbGwtbW9kdWxlczogYnQKCSQoTUFLRSkgLUMgJChLTElC
X0JVSUxEKSBNPSQoUFdEKSAkKEtNT0RESVJfQVJHKSAkKEtNT0RQQVRIX0FS
RykgQlQ9VFJVRSBcCgkJbW9kdWxlc19pbnN0YWxsCglAL3NiaW4vZGVwbW9k
IC1hZQoJQGVjaG8KCUBlY2hvICJDdXJyZW50bHkgZGV0ZWN0ZWQgYmx1ZXRv
b3RoIHN1YnN5c3RlbSBtb2R1bGVzOiIKCUBlY2hvCglAJChNT0RQUk9CRSkg
LWwgYXRoM2sgICAgICAgCglAJChNT0RQUk9CRSkgLWwgYmNtMjAzeAoJQCQo
TU9EUFJPQkUpIC1sIGJsdWVjYXJkX2NzCglAJChNT0RQUk9CRSkgLWwgYmx1
ZXRvb3RoCglAJChNT0RQUk9CRSkgLWwgYm5lcAoJQCQoTU9EUFJPQkUpIC1s
IGJwYTEweAoJQCQoTU9EUFJPQkUpIC1sIGJ0M2NfY3MKCUAkKE1PRFBST0JF
KSAtbCBidG1ydmwKCUAkKE1PRFBST0JFKSAtbCBidG1ydmxfc2RpbwoJQCQo
TU9EUFJPQkUpIC1sIGJ0c2RpbwoJQCQoTU9EUFJPQkUpIC1sIGJ0dXNiCglA
JChNT0RQUk9CRSkgLWwgYnR1YXJ0X2NzCglAJChNT0RQUk9CRSkgLWwJY210
cAoJQCQoTU9EUFJPQkUpIC1sCWR0bDFfY3MKCUAkKE1PRFBST0JFKSAtbCBo
aWRwCglAJChNT0RQUk9CRSkgLWwJaGNpX3ZoY2kKCUAkKE1PRFBST0JFKSAt
bAloY2lfdWFydAoJQCQoTU9EUFJPQkUpIC1sIGwyY2FwCglAJChNT0RQUk9C
RSkgLWwgcmZjb21tCglAJChNT0RQUk9CRSkgLWwgc2NvCglAZWNobwoJQGVj
aG8gTm93IHJ1bjoKCUBlY2hvCglAZWNobyBzdWRvIG1ha2UgYnR1bmxvYWQ6
CglAZWNobwoJQGVjaG8gQW5kIHRoZW4gbG9hZCB0aGUgbmVlZGVkIGJsdWV0
b290aCBtb2R1bGVzLiBJZiB1bnN1cmUgcmVib290LgoJQGVjaG8KCmJ0dW5p
bnN0YWxsOgoJQCMgTmV3IGxvY2F0aW9uLCBtYXRjaGVzIHVwc3RyZWFtCglA
cm0gLXJmICQoS0xJQikvJChLTU9ERElSKS9uZXQvYmx1ZXRvb3RoLwoJQHJt
IC1yZiAkKEtMSUIpLyQoS01PRERJUikvZHJpdmVycy9ibHVldG9vdGgvCglA
IyBMZXRzIG9ubHkgcmVtb3ZlIHRoZSBzdHVmZiB3ZSBhcmUgc3VyZSB3ZSBh
cmUgcHJvdmlkaW5nCglAIyBvbiB0aGUgbWlzYyBkaXJlY3RvcnkuCglAL3Ni
aW4vZGVwbW9kIC1hZQoJQGVjaG8KCUBlY2hvICJZb3VyIG9sZCBibHVldG9v
dGggc3Vic3lzdGVtIG1vZHVsZXMgd2VyZSBsZWZ0IGludGFjdDoiCglAZWNo
bwoJQCQoTU9EUFJPQkUpIC1sIGF0aDNrICAgICAgIAoJQCQoTU9EUFJPQkUp
IC1sIGJjbTIwM3gKCUAkKE1PRFBST0JFKSAtbCBibHVlY2FyZF9jcwoJQCQo
TU9EUFJPQkUpIC1sIGJsdWV0b290aAoJQCQoTU9EUFJPQkUpIC1sIGJuZXAK
CUAkKE1PRFBST0JFKSAtbCBicGExMHgKCUAkKE1PRFBST0JFKSAtbCBidDNj
X2NzCglAJChNT0RQUk9CRSkgLWwgYnRtcnZsCglAJChNT0RQUk9CRSkgLWwg
YnRtcnZsX3NkaW8KCUAkKE1PRFBST0JFKSAtbCBidHNkaW8KCUAkKE1PRFBS
T0JFKSAtbCBidHVzYgoJQCQoTU9EUFJPQkUpIC1sIGJ0dWFydF9jcwoJQCQo
TU9EUFJPQkUpIC1sCWNtdHAKCUAkKE1PRFBST0JFKSAtbAlkdGwxX2NzCglA
JChNT0RQUk9CRSkgLWwgaGlkcAoJQCQoTU9EUFJPQkUpIC1sCWhjaV92aGNp
CglAJChNT0RQUk9CRSkgLWwJaGNpX3VhcnQKCUAkKE1PRFBST0JFKSAtbCBs
MmNhcAoJQCQoTU9EUFJPQkUpIC1sIHJmY29tbQoJQCQoTU9EUFJPQkUpIC1s
IHNjbwoJQGVjaG8KCmJ0Y2xlYW46CgltYWtlIC1DIC9saWIvbW9kdWxlcy8k
KHNoZWxsIHVuYW1lIC1yKS9idWlsZCBNPSQoUFdEKSBCVD1UUlVFIGNsZWFu
CglAcm0gLWYgJChDUkVMX1BSRSkqCgppbnN0YWxsOiB1bmluc3RhbGwgaW5z
dGFsbC1tb2R1bGVzIGluc3RhbGwtc2NyaXB0cwoKaW5zdGFsbC1tb2R1bGVz
OiBtb2R1bGVzCgkkKE1BS0UpIC1DICQoS0xJQl9CVUlMRCkgTT0kKFBXRCkg
JChLTU9ERElSX0FSRykgJChLTU9EUEFUSF9BUkcpIFwKCQltb2R1bGVzX2lu
c3RhbGwKCmluc3RhbGwtc2NyaXB0czoKCUAjIEFsbCB0aGUgc2NyaXB0cyB3
ZSBjYW4gdXNlCglAbWtkaXIgLXAgJChERVNURElSKS91c3IvbGliL2NvbXBh
dC13aXJlbGVzcy8KCUBpbnN0YWxsIHNjcmlwdHMvbW9kbGliLnNoCSQoREVT
VERJUikvdXNyL2xpYi9jb21wYXQtd2lyZWxlc3MvCglAaW5zdGFsbCBzY3Jp
cHRzL21hZHdpZmktdW5sb2FkCSQoREVTVERJUikvdXNyL3NiaW4vCglAIyBU
aGlzIGlzIHRvIGFsbG93IHN3aXRjaGluZyBiZXR3ZWVuIGRyaXZlcnMgd2l0
aG91dCBibGFja2xpc3RpbmcKCUBpbnN0YWxsIHNjcmlwdHMvYXRoZW5hYmxl
CSQoREVTVERJUikvdXNyL3NiaW4vCglAaW5zdGFsbCBzY3JpcHRzL2I0M2Vu
YWJsZQkkKERFU1RESVIpL3Vzci9zYmluLwoJQGluc3RhbGwgc2NyaXB0cy9p
d2wtZW5hYmxlCSQoREVTVERJUikvdXNyL3NiaW4vCglAaW5zdGFsbCBzY3Jp
cHRzL2F0aGxvYWQJJChERVNURElSKS91c3Ivc2Jpbi8KCUBpbnN0YWxsIHNj
cmlwdHMvYjQzbG9hZAkkKERFU1RESVIpL3Vzci9zYmluLwoJQGluc3RhbGwg
c2NyaXB0cy9pd2wtbG9hZAkkKERFU1RESVIpL3Vzci9zYmluLwoJQGlmIFsg
ISAteiAiJChNQURXSUZJKSIgXSAmJiBbIC16ICIkKERFU1RESVIpIiBdOyB0
aGVuIFwKCQllY2hvIDtcCgkJZWNobyAtbiAiTm90ZTogbWFkd2lmaSBkZXRl
Y3RlZCwgd2UncmUgZ29pbmcgdG8gZGlzYWJsZSBpdC4gIiAgO1wKCQllY2hv
ICJJZiB5b3Ugd291bGQgbGlrZSB0byBlbmFibGUgaXQgbGF0ZXIgeW91IGNh
biBydW46IiAgO1wKCQllY2hvICIgICAgc3VkbyBhdGhlbmFibGUgbWFkd2lm
aSIgIDtcCgkJZWNobyA7XAoJCWVjaG8gUnVubmluZyBhdGhlbmFibGUgYXRo
NWsuLi47XAoJCS91c3Ivc2Jpbi9hdGhlbmFibGUgYXRoNWsgO1wKCWZpCglA
aWYgWyAhIC16ICIkKE9MRF9JV0wpIiBdICYmIFsgLXogIiQoREVTVERJUiki
IF07IHRoZW4gXAoJCWVjaG8gO1wKCQllY2hvIC1uICJOb3RlOiBpd2w0OTY1
IGRldGVjdGVkLCB3ZSdyZSBnb2luZyB0byBkaXNhYmxlIGl0LiAiICA7XAoJ
CWVjaG8gIklmIHlvdSB3b3VsZCBsaWtlIHRvIGVuYWJsZSBpdCBsYXRlciB5
b3UgY2FuIHJ1bjoiICA7XAoJCWVjaG8gIiAgICBzdWRvIGl3bC1sb2FkIGl3
bDQ5NjUiICA7XAoJCWVjaG8gO1wKCQllY2hvIFJ1bm5pbmcgaXdsLWVuYWJs
ZSBpd2xhZ24uLi47XAoJCS91c3Ivc2Jpbi9pd2wtZW5hYmxlIGl3bGFnbiA7
XAoJZmkKCUAjIElmIG9uIGRpc3RyaWJ1dGlvbnMgbGlrZSBNYW5kcml2YSB3
aGljaCBsaWtlIHRvCglAIyBjb21wcmVzcyB0aGVpciBtb2R1bGVzIHRoaXMg
d2lsbCBmaW5kIG91dCBhbmQgZG8KCUAjIGl0IGZvciB5b3UuIFJlYXNvbiBp
cyBzb21lIG9sZCB2ZXJzaW9uIG9mIG1vZHV0aWxzCglAIyB3b24ndCBrbm93
IG1hYzgwMjExLmtvIHNob3VsZCBiZSB1c2VkIGluc3RlYWQgb2YKCUAjIG1h
YzgwMjExLmtvLmd6CglALi9zY3JpcHRzL2NvbXByZXNzX21vZHVsZXMKCUAj
IE1hbmRyYWtlIGRvZXNuJ3QgaGF2ZSBhIGRlcG1vZC5kLyBjb25mIGZpbGUg
dG8gcHJlZmVyCglAIyB0aGUgdXBkYXRlcy8gZGlyIHdoaWNoIGlzIHdoYXQg
d2UgdXNlIHNvIHdlIGFkZCBvbmUgZm9yIGl0CglAIyAob3IgYW55IG90aGVy
IGRpc3RyaWJ1dGlvbiB0aGF0IGRvZW5zJ3QgaGF2ZSB0aGlzKS4KCUAuL3Nj
cmlwdHMvY2hlY2tfZGVwbW9kCglAIyBVZGV2IHN0dWZmIG5lZWRlZCBmb3Ig
dGhlIG5ldyBjb21wYXRfZmlybXdhcmVfY2xhc3MuCglALi9jb21wYXQvc2Ny
aXB0cy9jb21wYXRfZmlybXdhcmVfaW5zdGFsbAoJQC9zYmluL2RlcG1vZCAt
YQoJQGVjaG8KCUBlY2hvICJDdXJyZW50bHkgZGV0ZWN0ZWQgd2lyZWxlc3Mg
c3Vic3lzdGVtIG1vZHVsZXM6IgoJQGVjaG8gCglAJChNT0RQUk9CRSkgLWwg
bWFjODAyMTEKCUAkKE1PRFBST0JFKSAtbCBjZmc4MDIxMQoJQCQoTU9EUFJP
QkUpIC1sIGxpYjgwMjExCglAJChNT0RQUk9CRSkgLWwgYWRtODIxMQoJQCQo
TU9EUFJPQkUpIC1sIGFyOTE3MHVzYgoJQCQoTU9EUFJPQkUpIC1sIGF0NzZj
NTB4LXVzYgoJQCQoTU9EUFJPQkUpIC1sIGF0aAoJQCQoTU9EUFJPQkUpIC1s
IGF0aDVrCglAJChNT0RQUk9CRSkgLWwgYXRoNmtsCglAJChNT0RQUk9CRSkg
LWwgYXRoOWsKCUAkKE1PRFBST0JFKSAtbCBhdGg5a19odGMKCUAkKE1PRFBS
T0JFKSAtbCBiNDMKCUAkKE1PRFBST0JFKSAtbCBiNDNsZWdhY3kKCUAkKE1P
RFBST0JFKSAtbCBiNDQKCUAkKE1PRFBST0JFKSAtbCBjYXJsOTE3MAoJQCQo
TU9EUFJPQkUpIC1sIGJyY204MDIxMQoJQCQoTU9EUFJPQkUpIC1sIGNkY19l
dGhlcgoJQCQoTU9EUFJPQkUpIC1sIGVlcHJvbV85M2N4NgoJQCQoTU9EUFJP
QkUpIC1sIGlwdzIxMDAKCUAkKE1PRFBST0JFKSAtbCBpcHcyMjAwCglAJChN
T0RQUk9CRSkgLWwgaXdsMzk0NQoJQCQoTU9EUFJPQkUpIC1sIGl3bGFnbgoJ
QCQoTU9EUFJPQkUpIC1sIGl3bGNvcmUKCUAkKE1PRFBST0JFKSAtbCBpd21j
MzIwMHdpZmkKCUAkKE1PRFBST0JFKSAtbCBsaWI4MDIxMV9jcnlwdF9jY21w
CglAJChNT0RQUk9CRSkgLWwgbGliODAyMTFfY3J5cHRfdGtpcAoJQCQoTU9E
UFJPQkUpIC1sIGxpYjgwMjExX2NyeXB0X3dlcAoJQCQoTU9EUFJPQkUpIC1s
IGxpYmVydGFzCglAJChNT0RQUk9CRSkgLWwgbGliZXJ0YXNfY3MKCUAkKE1P
RFBST0JFKSAtbCBsaWJlcnRhc19zZGlvCglAJChNT0RQUk9CRSkgLWwgbGli
ZXJ0YXNfc3BpCglAJChNT0RQUk9CRSkgLWwgbGliZXJ0YXNfdGYKCUAkKE1P
RFBST0JFKSAtbCBsaWJlcnRhc190Zl91c2IKCUAkKE1PRFBST0JFKSAtbCBs
aWJpcHcKCUAkKE1PRFBST0JFKSAtbCBtYWM4MDIxMV9od3NpbQoJQCQoTU9E
UFJPQkUpIC1sIG13bDhrCglAJChNT0RQUk9CRSkgLWwgb3Jpbm9jb19jcwoJ
QCQoTU9EUFJPQkUpIC1sIG9yaW5vY29fbm9ydGVsCglAJChNT0RQUk9CRSkg
LWwgb3Jpbm9jb19wY2kKCUAkKE1PRFBST0JFKSAtbCBvcmlub2NvX3BseAoJ
QCQoTU9EUFJPQkUpIC1sIG9yaW5vY29fdGxkCglAJChNT0RQUk9CRSkgLWwg
b3Jpbm9jb191c2IKCUAkKE1PRFBST0JFKSAtbCBvcmlub2NvCglAJChNT0RQ
Uk9CRSkgLWwgcDU0Y29tbW9uCglAJChNT0RQUk9CRSkgLWwgcDU0cGNpCglA
JChNT0RQUk9CRSkgLWwgcDU0c3BpCglAJChNT0RQUk9CRSkgLWwgcDU0dXNi
CglAJChNT0RQUk9CRSkgLWwgcm5kaXNfaG9zdAoJQCQoTU9EUFJPQkUpIC1s
IHJuZGlzX3dsYW4KCUAkKE1PRFBST0JFKSAtbCBydDI0MDBwY2kKCUAkKE1P
RFBST0JFKSAtbCBydDI1MDBwY2kKCUAkKE1PRFBST0JFKSAtbCBydDI1MDB1
c2IKCUAkKE1PRFBST0JFKSAtbCBydDI4MDBwY2kKCUAkKE1PRFBST0JFKSAt
bCBydDI4MDB1c2IKCUAkKE1PRFBST0JFKSAtbCBydDJ4MDBsaWIKCUAkKE1P
RFBST0JFKSAtbCBydDJ4MDBwY2kKCUAkKE1PRFBST0JFKSAtbCBydDJ4MDB1
c2IKCUAkKE1PRFBST0JFKSAtbCBydDYxcGNpCglAJChNT0RQUk9CRSkgLWwg
cnQ3M3VzYgoJQCQoTU9EUFJPQkUpIC1sIHJ0bDgxODAKCUAkKE1PRFBST0JF
KSAtbCBydGw4MTg3CglAJChNT0RQUk9CRSkgLWwgcnRsd2lmaQoJQCQoTU9E
UFJPQkUpIC1sIHJ0bDgxOTJjZQoJQCQoTU9EUFJPQkUpIC1sIHNwZWN0cnVt
X2NzCglAJChNT0RQUk9CRSkgLWwgc3NiCglAJChNT0RQUk9CRSkgLWwgdXNi
OHh4eAoJQCQoTU9EUFJPQkUpIC1sIHVzYm5ldAoJQCQoTU9EUFJPQkUpIC1s
IHdsMTI1MQoJQCQoTU9EUFJPQkUpIC1sIHdsMTJ4eAoJQCQoTU9EUFJPQkUp
IC1sIHpkMTIxMXJ3CglAZWNobwoJQGVjaG8gIkN1cnJlbnRseSBkZXRlY3Rl
ZCBldGhlcm5ldCBzdWJzeXN0ZW0gbW9kdWxlczoiCglAZWNobwoJQCQoTU9E
UFJPQkUpIC1sIGF0bDEKCUAkKE1PRFBST0JFKSAtbCBhdGwyCglAJChNT0RQ
Uk9CRSkgLWwgYXRsMWUKCUAkKE1PRFBST0JFKSAtbCBhdGwxYwoJQGVjaG8K
CUBlY2hvICJDdXJyZW50bHkgZGV0ZWN0ZWQgYmx1ZXRvb3RoIHN1YnN5c3Rl
bSBtb2R1bGVzOiIKCUBlY2hvCglAJChNT0RQUk9CRSkgLWwgYXRoM2sgICAg
ICAgICAgIAoJQCQoTU9EUFJPQkUpIC1sIGJjbTIwM3gKCUAkKE1PRFBST0JF
KSAtbCBibHVlY2FyZF9jcwoJQCQoTU9EUFJPQkUpIC1sIGJsdWV0b290aAoJ
QCQoTU9EUFJPQkUpIC1sIGJuZXAKCUAkKE1PRFBST0JFKSAtbCBicGExMHgK
CUAkKE1PRFBST0JFKSAtbCBidDNjX2NzCglAJChNT0RQUk9CRSkgLWwgYnRt
cnZsCglAJChNT0RQUk9CRSkgLWwgYnRtcnZsX3NkaW8KCUAkKE1PRFBST0JF
KSAtbCBidHNkaW8KCUAkKE1PRFBST0JFKSAtbCBidHVzYgoJQCQoTU9EUFJP
QkUpIC1sIGJ0dWFydF9jcwoJQCQoTU9EUFJPQkUpIC1sCWNtdHAKCUAkKE1P
RFBST0JFKSAtbAlkdGwxX2NzCglAJChNT0RQUk9CRSkgLWwgaGlkcAoJQCQo
TU9EUFJPQkUpIC1sCWhjaV92aGNpCglAJChNT0RQUk9CRSkgLWwJaGNpX3Vh
cnQKCUAkKE1PRFBST0JFKSAtbCBsMmNhcAoJQCQoTU9EUFJPQkUpIC1sIHJm
Y29tbQoJQCQoTU9EUFJPQkUpIC1sIHNjbwoJQGVjaG8gCglAZWNobyBOb3cg
cnVuOgoJQGVjaG8gCglAZWNobyBzdWRvIG1ha2UgdW5sb2FkIHRvIHVubG9h
ZCBhbGw6IHdpcmVsZXNzLCBibHVldG9vdGggYW5kIGV0aGVybmV0IG1vZHVs
ZXMKCUBlY2hvIHN1ZG8gbWFrZSB3bHVubG9hZCB0byB1bmxvYWQgd2lyZWxl
c3MgbW9kdWxlcwoJQGVjaG8gc3VkbyBtYWtlIGJ0dW5sb2FkIHRvIHVubG9h
ZCBibHVldG9vdGggbW9kdWxlcwoJQGVjaG8KCUBlY2hvIFJ1biBzdWRvIG1v
ZHByb2JlICdkcml2ZXItbmFtZScgdG8gbG9hZCB5b3VyIGRlc2lyZWQgZHJp
dmVyLiAKCUBlY2hvIElmIHVuc3VyZSByZWJvb3QuCglAZWNobwoKdW5pbnN0
YWxsOgoJQCMgTmV3IGxvY2F0aW9uLCBtYXRjaGVzIHVwc3RyZWFtCglAcm0g
LXJmICQoS0xJQikvJChLTU9ERElSKS9jb21wYXQvCglAcm0gLXJmICQoS0xJ
QikvJChLTU9ERElSKS9uZXQvbWFjODAyMTEvCglAcm0gLXJmICQoS0xJQikv
JChLTU9ERElSKS9uZXQvcmZraWxsLwoJQHJtIC1yZiAkKEtMSUIpLyQoS01P
RERJUikvbmV0L3dpcmVsZXNzLwoJQHJtIC1yZiAkKEtMSUIpLyQoS01PRERJ
UikvZHJpdmVycy9zc2IvCglAcm0gLXJmICQoS0xJQikvJChLTU9ERElSKS9k
cml2ZXJzL25ldC91c2IvCglAcm0gLXJmICQoS0xJQikvJChLTU9ERElSKS9k
cml2ZXJzL25ldC93aXJlbGVzcy8KCUBybSAtcmYgJChLTElCKS8kKEtNT0RE
SVIpL2RyaXZlcnMvc3RhZ2luZy8KCUBybSAtcmYgJChLTElCKS8kKEtNT0RE
SVIpL2RyaXZlcnMvbmV0L2F0bCoKCUAjIExldHMgb25seSByZW1vdmUgdGhl
IHN0dWZmIHdlIGFyZSBzdXJlIHdlIGFyZSBwcm92aWRpbmcKCUAjIG9uIHRo
ZSBtaXNjIGRpcmVjdG9yeS4KCUBybSAtZiAkKEtMSUIpLyQoS01PRERJUikv
ZHJpdmVycy9taXNjL2VlcHJvbS9lZXByb21fOTNjeDYua28qCglAcm0gLWYg
JChLTElCKS8kKEtNT0RESVIpL2RyaXZlcnMvbWlzYy9lZXByb21fOTNjeDYu
a28qCglAcm0gLWYgJChLTElCKS8kKEtNT0RESVIpL2RyaXZlcnMvbmV0L2I0
NC5rbyoKCUAvc2Jpbi9kZXBtb2QgLWEKCUBlY2hvCglAZWNobyAiWW91ciBv
bGQgd2lyZWxlc3Mgc3Vic3lzdGVtIG1vZHVsZXMgd2VyZSBsZWZ0IGludGFj
dDoiCglAZWNobyAKCUAkKE1PRFBST0JFKSAtbCBtYWM4MDIxMQoJQCQoTU9E
UFJPQkUpIC1sIGNmZzgwMjExCglAJChNT0RQUk9CRSkgLWwgbGliODAyMTEK
CUAkKE1PRFBST0JFKSAtbCBhZG04MjExCglAJChNT0RQUk9CRSkgLWwgYXI5
MTcwdXNiCglAJChNT0RQUk9CRSkgLWwgYXQ3NmM1MHgtdXNiCglAJChNT0RQ
Uk9CRSkgLWwgYXRoCglAJChNT0RQUk9CRSkgLWwgYXRoNWsKCUAkKE1PRFBS
T0JFKSAtbCBhdGg2a2wKCUAkKE1PRFBST0JFKSAtbCBhdGg5awoJQCQoTU9E
UFJPQkUpIC1sIGF0aDlrX2h0YwoJQCQoTU9EUFJPQkUpIC1sIGI0MwoJQCQo
TU9EUFJPQkUpIC1sIGI0M2xlZ2FjeQoJQCQoTU9EUFJPQkUpIC1sIGI0NAoJ
QCQoTU9EUFJPQkUpIC1sIGNhcmw5MTcwCglAJChNT0RQUk9CRSkgLWwgYnJj
bTgwMjExCglAJChNT0RQUk9CRSkgLWwgY2RjX2V0aGVyCglAJChNT0RQUk9C
RSkgLWwgZWVwcm9tXzkzY3g2CglAJChNT0RQUk9CRSkgLWwgaXB3MjEwMAoJ
QCQoTU9EUFJPQkUpIC1sIGlwdzIyMDAKCUAkKE1PRFBST0JFKSAtbCBpd2wz
OTQ1CglAJChNT0RQUk9CRSkgLWwgaXdsYWduCglAJChNT0RQUk9CRSkgLWwg
aXdsY29yZQoJQCQoTU9EUFJPQkUpIC1sIGl3bWMzMjAwd2lmaQoJQCQoTU9E
UFJPQkUpIC1sIGxpYjgwMjExX2NyeXB0X2NjbXAKCUAkKE1PRFBST0JFKSAt
bCBsaWI4MDIxMV9jcnlwdF90a2lwCglAJChNT0RQUk9CRSkgLWwgbGliODAy
MTFfY3J5cHRfd2VwCglAJChNT0RQUk9CRSkgLWwgbGliZXJ0YXMKCUAkKE1P
RFBST0JFKSAtbCBsaWJlcnRhc19jcwoJQCQoTU9EUFJPQkUpIC1sIGxpYmVy
dGFzX3NkaW8KCUAkKE1PRFBST0JFKSAtbCBsaWJlcnRhc19zcGkKCUAkKE1P
RFBST0JFKSAtbCBsaWJlcnRhc190ZgoJQCQoTU9EUFJPQkUpIC1sIGxpYmVy
dGFzX3RmX3VzYgoJQCQoTU9EUFJPQkUpIC1sIGxpYmlwdwoJQCQoTU9EUFJP
QkUpIC1sIG1hYzgwMjExX2h3c2ltCglAJChNT0RQUk9CRSkgLWwgbXdsOGsK
CUAkKE1PRFBST0JFKSAtbCBvcmlub2NvX2NzCglAJChNT0RQUk9CRSkgLWwg
b3Jpbm9jb19ub3J0ZWwKCUAkKE1PRFBST0JFKSAtbCBvcmlub2NvX3BjaQoJ
QCQoTU9EUFJPQkUpIC1sIG9yaW5vY29fcGx4CglAJChNT0RQUk9CRSkgLWwg
b3Jpbm9jb190bGQKCUAkKE1PRFBST0JFKSAtbCBvcmlub2NvX3VzYgoJQCQo
TU9EUFJPQkUpIC1sIG9yaW5vY28KCUAkKE1PRFBST0JFKSAtbCBwNTRjb21t
b24KCUAkKE1PRFBST0JFKSAtbCBwNTRwY2kKCUAkKE1PRFBST0JFKSAtbCBw
NTRzcGkKCUAkKE1PRFBST0JFKSAtbCBwNTR1c2IKCUAkKE1PRFBST0JFKSAt
bCBybmRpc19ob3N0CglAJChNT0RQUk9CRSkgLWwgcm5kaXNfd2xhbgoJQCQo
TU9EUFJPQkUpIC1sIHJ0MjQwMHBjaQoJQCQoTU9EUFJPQkUpIC1sIHJ0MjUw
MHBjaQoJQCQoTU9EUFJPQkUpIC1sIHJ0MjUwMHVzYgoJQCQoTU9EUFJPQkUp
IC1sIHJ0MjgwMHBjaQoJQCQoTU9EUFJPQkUpIC1sIHJ0MjgwMHVzYgoJQCQo
TU9EUFJPQkUpIC1sIHJ0MngwMGxpYgoJQCQoTU9EUFJPQkUpIC1sIHJ0Mngw
MHBjaQoJQCQoTU9EUFJPQkUpIC1sIHJ0MngwMHVzYgoJQCQoTU9EUFJPQkUp
IC1sIHJ0NjFwY2kKCUAkKE1PRFBST0JFKSAtbCBydDczdXNiCglAJChNT0RQ
Uk9CRSkgLWwgcnRsODE4MAoJQCQoTU9EUFJPQkUpIC1sIHJ0bDgxODcKCUAk
KE1PRFBST0JFKSAtbCBydGx3aWZpCglAJChNT0RQUk9CRSkgLWwgcnRsODE5
MmNlCglAJChNT0RQUk9CRSkgLWwgc3BlY3RydW1fY3MKCUAkKE1PRFBST0JF
KSAtbCBzc2IKCUAkKE1PRFBST0JFKSAtbCB1c2I4eHh4CglAJChNT0RQUk9C
RSkgLWwgdXNibmV0CglAJChNT0RQUk9CRSkgLWwgd2wxMjUxCglAJChNT0RQ
Uk9CRSkgLWwgd2wxMnh4CglAJChNT0RQUk9CRSkgLWwgemQxMjExcncKCUBl
Y2hvCglAZWNobyAiWW91ciBvbGQgZXRoZXJuZXQgc3Vic3lzdGVtIG1vZHVs
ZXMgYXJlIGxlZnQgaW50YWN0OiIKCUBlY2hvCglAJChNT0RQUk9CRSkgLWwg
YXRsMQoJQCQoTU9EUFJPQkUpIC1sIGF0bDIKCUAkKE1PRFBST0JFKSAtbCBh
dGwxZQoJQCQoTU9EUFJPQkUpIC1sIGF0bDFjCglAZWNobwoJQGVjaG8gIllv
dXIgb2xkIGJsdWV0b290aCBzdWJzeXN0ZW0gbW9kdWxlcyB3ZXJlIGxlZnQg
aW50YWN0OiIKCUBlY2hvCglAJChNT0RQUk9CRSkgLWwgYXRoM2sgICAgICAg
ICAgIAoJQCQoTU9EUFJPQkUpIC1sIGJjbTIwM3gKCUAkKE1PRFBST0JFKSAt
bCBibHVlY2FyZF9jcwoJQCQoTU9EUFJPQkUpIC1sIGJsdWV0b290aAoJQCQo
TU9EUFJPQkUpIC1sIGJuZXAKCUAkKE1PRFBST0JFKSAtbCBicGExMHgKCUAk
KE1PRFBST0JFKSAtbCBidDNjX2NzCglAJChNT0RQUk9CRSkgLWwgYnRtcnZs
CglAJChNT0RQUk9CRSkgLWwgYnRtcnZsX3NkaW8KCUAkKE1PRFBST0JFKSAt
bCBidHNkaW8KCUAkKE1PRFBST0JFKSAtbCBidHVzYgoJQCQoTU9EUFJPQkUp
IC1sIGJ0dWFydF9jcwoJQCQoTU9EUFJPQkUpIC1sCWNtdHAKCUAkKE1PRFBS
T0JFKSAtbAlkdGwxX2NzCglAJChNT0RQUk9CRSkgLWwgaGlkcAoJQCQoTU9E
UFJPQkUpIC1sCWhjaV92aGNpCglAJChNT0RQUk9CRSkgLWwJaGNpX3VhcnQK
CUAkKE1PRFBST0JFKSAtbCBsMmNhcAoJQCQoTU9EUFJPQkUpIC1sIHJmY29t
bQoJQCQoTU9EUFJPQkUpIC1sIHNjbwoJQAoJQGVjaG8gCgpjbGVhbjoKCUBp
ZiBbIC1kIG5ldCAtYSAtZCAkKEtMSUJfQlVJTEQpIF07IHRoZW4gXAoJCSQo
TUFLRSkgLUMgJChLTElCX0JVSUxEKSBNPSQoUFdEKSBjbGVhbiA7XAoJZmkK
CUBybSAtZiAkKENSRUxfUFJFKSoKdW5sb2FkOgoJQC4vc2NyaXB0cy91bmxv
YWQuc2gKCmJ0dW5sb2FkOgoJQC4vc2NyaXB0cy9idHVubG9hZC5zaAoKd2x1
bmxvYWQ6CglALi9zY3JpcHRzL3dsdW5sb2FkLnNoCgoKLlBIT05ZOiBhbGwg
Y2xlYW4gaW5zdGFsbCB1bmluc3RhbGwgdW5sb2FkIGJ0dW5sb2FkIHdsdW5s
b2FkIG1vZHVsZXMgYnQKCmVuZGlmCgpjbGVhbi1maWxlcyArPSBNb2R1bGUu
c3ltdmVycyBNb2R1bGUubWFya2VycyBtb2R1bGVzIG1vZHVsZXMub3JkZXIK
Y2xlYW4tZmlsZXMgKz0gJChDUkVMX0NIRUNLKSAkKENPTkZJR19DSEVDSykK


--0-484645885-1297386899=:47352--

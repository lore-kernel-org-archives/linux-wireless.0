Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:61111 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbZHYTJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 15:09:11 -0400
Received: by iwn42 with SMTP id 42so1391645iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 12:09:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A94319B.9030903@wildgooses.com>
References: <4A94319B.9030903@wildgooses.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 25 Aug 2009 12:08:53 -0700
Message-ID: <43e72e890908251208r1451b54bt36b431ba5942917a@mail.gmail.com>
Subject: Re: Cross compiling currently broken?
To: Ed W <lists@wildgooses.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 11:46 AM, Ed W<lists@wildgooses.com> wrote:
> /lib/modules/xyz.

I use /lib/modules/xyz/build just fine.

mcgrof@tux ~/devel/compat-wireless-2.6 (git::master)$
./scripts/driver-select ath9k
Processing new driver-select request...
Backing up makefile: Makefile.bk
Backing up makefile: drivers/net/wireless/Makefile.bk
Backing up makefile: drivers/net/wireless/ath/Makefile.bk
Backing up makefile: net/wireless/Makefile.bk
Backing up makefile: drivers/ssb/Makefile.bk
Backing up makefile: drivers/net/usb/Makefile.bk
Backing up makefile: drivers/misc/eeprom/Makefile.bk

mcgrof@tux ~/devel/compat-wireless-2.6 (git::master)$ make
KLIB=/lib/modules/2.6.27-02062726-generic/build/
KLIB_BUILD=/lib/modules/2.6.27-02062726-generic/build/
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.27-02062726-generic/build/
M=/home/mcgrof/devel/compat-wireless-2.6 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.27-02062726-generic'
  LD      /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/built-in.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/main.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/regd.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath.o
  LD      /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/built-in.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/hw.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/eeprom.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/eeprom_def.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/eeprom_4k.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/eeprom_9287.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/mac.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/calib.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/ani.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/phy.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/beacon.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/main.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/recv.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/xmit.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/virtual.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/rc.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/pci.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/ath9k.o
  LD      /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/built-in.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/main.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/sta_info.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/wep.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/wpa.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/scan.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/ht.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/agg-tx.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/agg-rx.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/ibss.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/mlme.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/iface.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rate.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/michael.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/tkip.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/aes_ccm.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/aes_cmac.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/cfg.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rx.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/spectmgmt.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/tx.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/key.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/util.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/wme.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/event.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/led.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/debugfs.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/debugfs_sta.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/debugfs_netdev.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/debugfs_key.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/mesh.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/mesh_pathtbl.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/mesh_plink.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/mesh_hwmp.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/pm.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rc80211_pid_algo.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rc80211_pid_debugfs.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rc80211_minstrel.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rc80211_minstrel_debugfs.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/mac80211.o
  LD      /home/mcgrof/devel/compat-wireless-2.6/net/rfkill/built-in.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/rfkill/core.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/rfkill/input.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/net/rfkill/rfkill_backport.o
  LD      /home/mcgrof/devel/compat-wireless-2.6/net/wireless/built-in.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/core.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/sysfs.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/radiotap.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/util.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/reg.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/scan.o
/home/mcgrof/devel/compat-wireless-2.6/net/wireless/scan.c: In
function ‘cfg80211_bss_update’:
/home/mcgrof/devel/compat-wireless-2.6/net/wireless/scan.c:422:
warning: unused variable ‘used’
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/nl80211.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/mlme.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/ibss.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/sme.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/chan.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/wext-compat.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/wext-sme.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/compat-2.6.28.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/compat-2.6.29.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/compat-2.6.30.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/compat-2.6.31.o
  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/compat-2.6.32.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/cfg80211.o
  LD      /home/mcgrof/devel/compat-wireless-2.6/built-in.o
  Building modules, stage 2.
  MODPOST 5 modules
  CC      /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath.mod.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath.ko
  CC      /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/ath9k.mod.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/drivers/net/wireless/ath/ath9k/ath9k.ko
  CC      /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/mac80211.mod.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/mac80211.ko
  CC      /home/mcgrof/devel/compat-wireless-2.6/net/rfkill/rfkill_backport.mod.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/net/rfkill/rfkill_backport.ko
  CC      /home/mcgrof/devel/compat-wireless-2.6/net/wireless/cfg80211.mod.o
  LD [M]  /home/mcgrof/devel/compat-wireless-2.6/net/wireless/cfg80211.ko
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-02062726-generic'

  Luis
  Luis

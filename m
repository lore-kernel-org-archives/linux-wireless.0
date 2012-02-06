Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:43686 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2BFEwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 23:52:40 -0500
Received: by qafk1 with SMTP id k1so3438464qaf.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Feb 2012 20:52:40 -0800 (PST)
Message-ID: <4F2F5C89.9050809@gmail.com> (sfid-20120206_055309_930861_A0FDC678)
Date: Sun, 05 Feb 2012 23:52:25 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Masashi Honma <masashi.honma@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Failed to compile stable compat-wireless 3.2.1
References: <CAFk-A4=0ZDHaJ6KQnY8JTvx_kCjDvNooZpmeUJs5c4Z7NzvkNA@mail.gmail.com>
In-Reply-To: <CAFk-A4=0ZDHaJ6KQnY8JTvx_kCjDvNooZpmeUJs5c4Z7NzvkNA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/12 22:06, Masashi Honma wrote:
> Hello.
>
> I tried to compile stable compat-wireless 3.2.1.
> I used the source code here.
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.2/compat-wireless-3.2-1.tar.bz2
>
> My environment is Debian 6.0.3.
>
> My linux kernel is 3.2.1.
> I used the source code here.
> http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.2.1.tar.bz2
>From the compat-wireless stable website a quote:

" *NOTE:* Please be aware that the releases below contain
code /from/ the given version of the Linux kernel. Therefore to add
functionality, you should select a version that is /later/ than your
kernel version."

So, what exactly are you trying to do? You are adding wireless modules
from kernel 3.2.1 to kernel 3.2.1..... seems like you are done before
you began.

-Rick
>
> I typed
>
> $ tar xjf compat-wireless-3.2-1.tar.bz2
> $ cd compat-wireless-3.2-1
> $ ./scripts/driver-select ath9k
> $ make
>
> But I have gotten compile error.
>
> How to erase this error ?
>
> I pasted full log.
>
> -----------
> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
> make -C /lib/modules/3.2.1/build M=/home/honma/compat-wireless-3.2-1 modules
> make[1]: Entering directory `/usr/src/linux-source-3.2.1'
>   LD      /home/honma/compat-wireless-3.2-1/compat/built-in.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/compat/main.o
>   LD [M]  /home/honma/compat-wireless-3.2-1/compat/compat.o
>   LD      /home/honma/compat-wireless-3.2-1/drivers/net/wireless/built-in.o
>   LD      /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/built-in.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/main.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/regd.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/hw.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/key.o
>   LD [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath.o
>   LD      /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/built-in.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/beacon.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/gpio.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/init.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/main.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/recv.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/xmit.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/rc.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/pci.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/common.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/htc_hst.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/hif_usb.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/wmi.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/htc_drv_txrx.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/htc_drv_main.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/htc_drv_beacon.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/htc_drv_init.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/htc_drv_gpio.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9002_hw.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9003_hw.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/hw.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9003_phy.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9002_phy.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar5008_phy.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9002_calib.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9003_calib.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9003_rtt.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/calib.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/eeprom.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/eeprom_def.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/eeprom_4k.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/eeprom_9287.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ani.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/btcoex.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/mac.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9002_mac.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9003_mac.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9003_eeprom.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ar9003_paprd.o
>   LD [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ath9k.o
>   LD [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ath9k_hw.o
>   LD [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ath9k_common.o
>   LD [M]  /home/honma/compat-wireless-3.2-1/drivers/net/wireless/ath/ath9k/ath9k_htc.o
>   LD      /home/honma/compat-wireless-3.2-1/net/mac80211/built-in.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/main.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/status.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/sta_info.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/wep.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/wpa.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/scan.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/offchannel.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/ht.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/agg-tx.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/agg-rx.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/ibss.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/mlme.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/work.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/iface.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/rate.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/michael.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/tkip.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/aes_ccm.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/aes_cmac.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/cfg.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/rx.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/spectmgmt.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/tx.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/key.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/util.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/wme.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/event.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/chan.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/led.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/mesh.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/mesh_pathtbl.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/mesh_plink.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/mesh_hwmp.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/pm.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/rc80211_pid_algo.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/rc80211_minstrel.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/rc80211_minstrel_ht.o
>   LD [M]  /home/honma/compat-wireless-3.2-1/net/mac80211/mac80211.o
>   LD      /home/honma/compat-wireless-3.2-1/net/rfkill/built-in.o
>   LD      /home/honma/compat-wireless-3.2-1/net/wireless/built-in.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/wireless/core.o
> /home/honma/compat-wireless-3.2-1/net/wireless/core.c:7:1: warning:
> "pr_fmt" redefined
> In file included from
> /home/honma/compat-wireless-3.2-1/include/linux/printk.h:7,
>                  from include/linux/kernel.h:20,
>                  from include/linux/skbuff.h:17,
>                  from include/linux/if_ether.h:133,
>                  from include/linux/netdevice.h:29,
>                  from
> /home/honma/compat-wireless-3.2-1/include/linux/compat-2.6.29.h:5,
>                  from
> /home/honma/compat-wireless-3.2-1/include/linux/compat-2.6.h:24,
>                  from <command-line>:0:
> include/linux/printk.h:152:1: warning: this is the location of the
> previous definition
> /home/honma/compat-wireless-3.2-1/net/wireless/core.c:7:1: warning:
> "pr_fmt" redefined
> In file included from
> /home/honma/compat-wireless-3.2-1/include/linux/printk.h:7,
>                  from include/linux/kernel.h:20,
>                  from include/linux/skbuff.h:17,
>                  from include/linux/if_ether.h:133,
>                  from include/linux/netdevice.h:29,
>                  from
> /home/honma/compat-wireless-3.2-1/include/linux/compat-2.6.29.h:5,
>                  from
> /home/honma/compat-wireless-3.2-1/include/linux/compat-2.6.h:24,
>                  from <command-line>:0:
> include/linux/printk.h:152:1: warning: this is the location of the
> previous definition
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/wireless/sysfs.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/wireless/radiotap.o
>   CC [M]  /home/honma/compat-wireless-3.2-1/net/wireless/util.o
> /home/honma/compat-wireless-3.2-1/net/wireless/util.c: In function
> 'cfg80211_change_iface':
> /home/honma/compat-wireless-3.2-1/net/wireless/util.c:810: error:
> implicit declaration of function 'br_port_exists'
> make[3]: *** [/home/honma/compat-wireless-3.2-1/net/wireless/util.o] Error 1
> make[2]: *** [/home/honma/compat-wireless-3.2-1/net/wireless] Error 2
> make[1]: *** [_module_/home/honma/compat-wireless-3.2-1] Error 2
> make[1]: Leaving directory `/usr/src/linux-source-3.2.1'
> make: *** [modules] Error 2
> -----------
>
> Regards,
> Masashi Honma.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


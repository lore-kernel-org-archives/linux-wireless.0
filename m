Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38935 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab0DWAU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 20:20:26 -0400
Received: by vws14 with SMTP id 14so309254vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 17:20:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: seco.wu@gmail.com
In-Reply-To: <v2ne4fca08d1004221625o4eb31e79ke1043f0c9a8e686f@mail.gmail.com>
References: <v2ne4fca08d1004221625o4eb31e79ke1043f0c9a8e686f@mail.gmail.com>
Date: Fri, 23 Apr 2010 08:20:25 +0800
Message-ID: <t2qe4fca08d1004221720gc8551b6bq21fb043eb9128f56@mail.gmail.com>
Subject: Re: update compat drivers,adpter can not be work,4 help.tks
From: SECO <secowu@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

& this is the full log


./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.30.9/build M=/root/compat-wireless-2.6.34-rc4 modules
make[1]: Entering directory `/usr/src/linux-source-2.6.30.9'

  WARNING: Symbol version dump /usr/src/linux-source-2.6.30.9/Module.symvers
           is missing; modules will have no dependencies and modversions.

  CC [M]  /root/compat-wireless-2.6.34-rc4/compat/main.o
....
  CC [M]  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/mac80211_hwsim.o
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/mac80211_hwsim.c: In funct
ion ‘__check_fake_hw_scan’:
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/mac80211_hwsim.c:37: warni
ng: return from incompatible pointer type
...
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/main.c: In
function ‘b43_request_firmware’:
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/main.c:2271:
warning: format not a string literal and no format
 arguments
...
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:442:
warning: ‘b43_nphy_rx_cal_phy_cleanup’ defined but
 not used
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:465:
warning: ‘b43_nphy_rx_cal_phy_setup’ defined but n
ot used
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:1462:
warning: ‘b43_nphy_bphy_init’ defined but not use
d
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c: In
function ‘b43_nphy_spur_workaround’:
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:739:
warning: ‘channel’ may be used uninitialized in th
is function
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c: In
function ‘b43_nphy_cal_tx_iq_lo’:
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:2519:
warning: ‘last’ may be used uninitialized in this
 function
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c: In
function ‘b43_nphy_rev2_cal_rx_iq’:
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:2774:
warning: ‘cur_hpf2’ may be used uninitialized in
this function
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:2774:
warning: ‘cur_hpf1’ may be used uninitialized in
this function
...
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/ipw2x00/libipw_wx.c:
In function ‘libipw_wx_set_encodeext’:
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/ipw2x00/libipw_wx.c:623:
warning: format not a string literal and n
o format arguments
  CC [M]  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/ipw2x00/libipw_geo.o
 ...
  CC [M]  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-5000.o
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-5000.c:
In function ‘iwl5000_gain_computation’:
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-5000.c:189:
warning: comparison of distinct pointer typ
es lacks a cast
  CC [M]  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-6000.o
  CC [M]  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-1000.o
  CC [M]  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-core.o
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-core.c:
In function ‘__check_bt_coex_active’:
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-core.c:68:
warning: return from incompatible pointer ty
pe
  CC [M]  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-eeprom.o
  CC [M]  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-hcmd.o
  CC [M]  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-power.o
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-power.c:
In function ‘__check_no_sleep_autoadjust’:
/root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-power.c:58:
warning: return from incompatible pointer t
ype
...
  CC [M]  /root/compat-wireless-2.6.34-rc4/net/bluetooth/hidp/core.o
/root/compat-wireless-2.6.34-rc4/net/bluetooth/hidp/core.c: In
function ‘hidp_setup_hid’:
/root/compat-wireless-2.6.34-rc4/net/bluetooth/hidp/core.c:872:
warning: assignment from incompatible pointer type
  CC [M]  /root/compat-wireless-2.6.34-rc4/net/bluetooth/hidp/sock.o
...
  CC [M]  /root/compat-wireless-2.6.34-rc4/net/mac80211/main.o
/root/compat-wireless-2.6.34-rc4/net/mac80211/main.c: In function
‘__check_ieee80211_disable_40mhz_24ghz’:
/root/compat-wireless-2.6.34-rc4/net/mac80211/main.c:39: warning:
return from incompatible pointer type
  CC [M]  /root/compat-wireless-2.6.34-rc4/net/mac80211/status.o

sudo make install
...
make -C /lib/modules/2.6.30.9/build M=/root/compat-wireless-2.6.34-rc4 modules
make[1]: Entering directory `/usr/src/linux-source-2.6.30.9'

  WARNING: Symbol version dump /usr/src/linux-source-2.6.30.9/Module.symvers
           is missing; modules will have no dependencies and modversions.

.......
 INSTALL /root/compat-wireless-2.6.34-rc4/net/wireless/lib80211_crypt_wep.ko
  DEPMOD  2.6.30.9
make[1]: Leaving directory `/usr/src/linux-source-2.6.30.9'
Updating Ubuntu's initramfs for 2.6.31-wl under /boot/ ...
Cannot find /lib/modules/2.6.31-wl
Will now run update-grub to ensure grub will find the new initramfs ...
Searching for GRUB installation directory ... found: /boot/grub
Searching for default file ... found: /boot/grub/default
Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
Searching for splash image ... found: /boot/grub/splash.xpm.gz
Found kernel: /boot/vmlinuz-2.6.30.9
Found kernel: /boot/memtest86+.bin
Updating /boot/grub/menu.lst ... done

depmod will prefer updates/ over kernel/ -- OK!

Currently detected wireless subsystem modules:

/lib/modules/2.6.30.9/updates/net/mac80211/mac80211.ko
/lib/modules/2.6.30.9/updates/net/wireless/cfg80211.ko
/lib/modules/2.6.30.9/updates/net/wireless/lib80211.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/adm8211.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/ath/ar9170/ar9170usb.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/at76c50x-usb.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/ath/ath.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/ath/ath9k/ath9k.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/b43/b43.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/b43legacy/b43legacy.ko
/lib/modules/2.6.30.9/updates/drivers/net/usb/cdc_ether.ko
/lib/modules/2.6.30.9/updates/drivers/misc/eeprom/eeprom_93cx6.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/ipw2x00/ipw2100.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/ipw2x00/ipw2200.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/iwlwifi/iwl3945.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/iwlwifi/iwlagn.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/iwlwifi/iwlcore.ko
/lib/modules/2.6.30.9/updates/net/wireless/lib80211_crypt_ccmp.ko
/lib/modules/2.6.30.9/updates/net/wireless/lib80211_crypt_tkip.ko
/lib/modules/2.6.30.9/updates/net/wireless/lib80211_crypt_wep.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas/libertas.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas/libertas_cs.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas/libertas_sdio.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas_tf/libertas_tf.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas_tf/libertas_tf_usb.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/ipw2x00/libipw.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/mac80211_hwsim.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/mwl8k.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/p54/p54common.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/p54/p54pci.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/p54/p54usb.ko
/lib/modules/2.6.30.9/updates/drivers/net/usb/rndis_host.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rndis_wlan.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2400pci.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2500pci.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2500usb.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2x00pci.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2x00usb.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt61pci.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt73usb.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rtl818x/rtl8180.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/rtl818x/rtl8187.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas/usb8xxx.ko
/lib/modules/2.6.30.9/updates/drivers/net/usb/usbnet.ko
/lib/modules/2.6.30.9/updates/drivers/net/wireless/zd1211rw/zd1211rw.ko

Currently detected bluetooth subsystem modules:

/lib/modules/2.6.30.9/updates/net/bluetooth/sco.ko
/lib/modules/2.6.30.9/updates/net/bluetooth/l2cap.ko
/lib/modules/2.6.30.9/updates/net/bluetooth/hidp/hidp.ko
/lib/modules/2.6.30.9/updates/net/bluetooth/rfcomm/rfcomm.ko
/lib/modules/2.6.30.9/updates/net/bluetooth/bnep/bnep.ko
/lib/modules/2.6.30.9/updates/drivers/bluetooth/btusb.ko
/lib/modules/2.6.30.9/updates/net/bluetooth/bluetooth.ko

Now run:

sudo make unload to unload both wireless and bluetooth modules
sudo make wlunload to unload wireless modules
sudo make btunload to unload bluetooth modules

And then load the wireless or bluetooth module you need. If unsure reboot.
Alternatively use sudo make load/wlload/btload to load modules

root@bt:~/compat-wireless-2.6.34-rc4#
root@bt:~/compat-wireless-2.6.34-rc4# sudo make unload
Stoping bluetooth service..
Stopping bluetooth: bluetoothd.
* bluetooth is not running.
Unloading ar9170usb...
Unloading rfcomm...
Unloading btusb...
root@bt:~/compat-wireless-2.6.34-rc4# sudo make wlunload
root@bt:~/compat-wireless-2.6.34-rc4# sudo make btunload
Stoping bluetooth service..
Stopping bluetooth: bluetoothd.
* bluetooth is not running.
Unloading rfcomm...
root@bt:~/compat-wireless-2.6.34-rc4#
root@bt:~/compat-wireless-2.6.34-rc4# sudo make load
Stoping bluetooth service..
Stopping bluetooth: bluetoothd.
* bluetooth is not running.
Unloading rfcomm...
Loading ipw2100...
Loading ipw2200...
Loading libertas_cs...
Loading usb8xxx...
Loading p54pci...
Loading p54usb...
Loading adm8211...
Loading zd1211rw...
Loading rtl8180...
Loading rtl8187...
Loading p54pci...
Loading p54usb...
Loading iwl3945...
Loading iwlagn...
Loading ath...
Loading ar9170usb...
Loading rtl8180...
Loading rtl8187...
Loading rt2400pci...
Loading rt2500pci...
Loading rt61pci...
Loading rt2500usb...
Loading rt73usb...
Loading rndis_wlan...
Loading at76_usb...
FATAL: Module at76_usb not found.
Loading mwl8k...
Loading mac80211_hwsim...
Loading at76c50x_usb...
Loading bluetooth...
Loading btusb...
Loading l2cap...
Loading sco...
Loading hidp...
Loading rfcomm...
Loading bnep...
Module ath_pci not detected -- this is fine
ath5k loaded successfully
ath9k loaded successfully
Module bcm43xx not detected -- this is fine
Module wl not detected -- this is fine
FATAL: Error inserting b43
(/lib/modules/2.6.30.9/updates/drivers/net/wireless/b43/b43.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
b43 loaded successfully
b43legacy loaded successfully
Starting bluetooth service..
Starting bluetooth: bluetoothd.
bluetooth is running.


2010/4/23, SECO <secowu@gmail.com>:
> Hi,Sir.
>
>    I use BT4,after Updated drivers, the original adpter bcm4311 can not be
> work.
> Not mention WN721 and WN821N .
> & log here
>
> root@bt:~# ln -s /usr/src/linux /lib/modules/2.6.30.9/build
> root@bt:~# wget
> http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2010-04-21.tar.bz2
> --2010-04-22 21:21:31--
> http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2010-04-21.tar.bz2
> Resolving wireless.kernel.org... 78.46.109.217
> Connecting to wireless.kernel.org|78.46.109.217|:80... connected.
> HTTP request sent, awaiting response... 200 OK
> Length: 2424098 (2.3M) [application/octet-stream]
> Saving to: `compat-wireless-2010-04-21.tar.bz2'
>
> 100%[==================================================================================================================>]
> 2,424,098   44.0K/s   in 56s
>
> 2010-04-22 21:22:29 (42.1 KB/s) - `compat-wireless-2010-04-21.tar.bz2'
> saved [2424098/2424098]
>
> root@bt:~# tar -xf compat-wireless-2010-04-21.tar.bz2
> root@bt:~# cd compat-wireless-2010-04-21.tar.bz22.make & make install
>
> Code:
> oot@bt:~/compat-wireless-2010-04-21# sudo make && sudo make install
> make -C /lib/modules/2.6.30.9/build M=/root/compat-wireless-2010-04-21
> modules
> make[1]: Entering directory `/usr/src/linux-source-2.6.30.9'
> ....
> CC [M]  /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/main.o
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/main.c: In
> function ‘b43_request_firmware’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/main.c:2271:
> warning: format not a string literal and no format arguments
> ....
> root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:465:
> warning: ‘b43_nphy_rx_cal_phy_cleanup’ defined but not used
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:488:
> warning: ‘b43_nphy_rx_cal_phy_setup’ defined but not used
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:1574:
> warning: ‘b43_nphy_bphy_init’ defined but not used
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c: In
> function ‘b43_nphy_set_chanspec’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:3376:
> warning: ‘tabent_r3’ may be used uninitialized in this function
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c: In
> function ‘b43_nphy_cal_tx_iq_lo’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:2631:
> warning: ‘last’ may be used uninitialized in this function
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c: In
> function ‘b43_nphy_rev2_cal_rx_iq’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:2886:
> warning: ‘cur_hpf2’ may be used uninitialized in this function
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:2886:
> warning: ‘cur_hpf1’ may be used uninitialized in this function
> ...
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/xmit.c: In
> function ‘b43_rx’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/xmit.c:613:
> warning: ‘noise’ is deprecated (declared at
> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
> ...
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43legacy/xmit.c:
> In function ‘b43legacy_rx’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43legacy/xmit.c:551:
> warning: ‘noise’ is deprecated (declared at
> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
> ...
> /root/compat-wireless-2010-04-21/drivers/net/wireless/ipw2x00/libipw_wx.c:
> In function ‘libipw_wx_set_encodeext’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/ipw2x00/libipw_wx.c:623:
> warning: format not a string literal and no format arguments
> ...
> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c:
> In function ‘iwlagn_gain_computation’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c:145:
> warning: comparison of distinct pointer types lacks a cast
> ...
> root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-core.c:
> In function ‘__check_bt_coex_active’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-core.c:68:
> warning: return from incompatible pointer type
>   CC [M]
> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-eeprom.o
>   CC [M]
> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-hcmd.o
>   CC [M]
> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-power.o
> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-power.c:
> In function ‘__check_no_sleep_autoadjust’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-power.c:58:
> warning: return from incompatible pointer type
> ....
> root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/if_sdio.c:
> In function ‘if_sdio_probe’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/if_sdio.c:948:
> warning: unused variable ‘host’
>   CC [M]
> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/if_usb.o
>   LD [M]
> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/libertas.o
>   LD [M]
> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/usb8xxx.o
>   LD [M]
> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/libertas_cs.o
>   LD [M]
> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/libertas_sdio.o
>   CC [M]
> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas_tf/main.o
> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas_tf/main.c:
> In function ‘lbtf_rx’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas_tf/main.c:513:
> warning: ‘noise’ is deprecated (declared at
> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
>   CC [M]  /root/compat-wireless-2010-
> ...
> root/compat-wireless-2010-04-21/drivers/net/wireless/p54/txrx.c: In
> function ‘p54_rx_data’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/p54/txrx.c:353:
> warning: ‘noise’ is deprecated (declared at
> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
> ...
> /root/compat-wireless-2010-04-21/drivers/net/wireless/rt2x00/rt2x00dev.c:
> In function ‘rt2x00lib_rxdone’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/rt2x00/rt2x00dev.c:438:
> warning: ‘noise’ is deprecated (declared at
> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
> ...
> /root/compat-wireless-2010-04-21/drivers/net/wireless/wl12xx/wl1251_rx.c:
> In function ‘wl1251_rx_status’:
> /root/compat-wireless-2010-04-21/drivers/net/wireless/wl12xx/wl1251_rx.c:81:
> warning: ‘noise’ is deprecated (declared at
> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
> ...
> root/compat-wireless-2010-04-21/net/bluetooth/hidp/core.c: In function
> ‘hidp_setup_hid’:
> /root/compat-wireless-2010-04-21/net/bluetooth/hidp/core.c:872:
> warning: assignment from incompatible pointer type
> ....
> /root/compat-wireless-2010-04-21/net/mac80211/main.c: In function
> ‘__check_ieee80211_disable_40mhz_24ghz’:
> /root/compat-wireless-2010-04-21/net/mac80211/main.c:37: warning:
> return from incompatible pointer type
> ...& download ar9271.fw form herer
> '[PATCH 0/3] ath9k: add initial ar9271 support' - MARC
>
> Code:
>
> root@bt:~/compat-wireless-2010-04-21# make load
> Stoping bluetooth service..
> Stopping bluetooth: bluetoothd.
> * bluetooth is not running.
> Unloading b43...
> Unloading ar9170usb...
> Unloading lib80211...
> FATAL: Module lib80211 is in use.
> Unloading btusb...
> Loading ipw2100...
> Loading ipw2200...
> Loading libertas_cs...
> Loading usb8xxx...
> Loading p54pci...
> Loading p54usb...
> Loading adm8211...
> Loading zd1211rw...
> Loading rtl8180...
> Loading rtl8187...
> Loading p54pci...
> Loading p54usb...
> Loading iwl3945...
> Loading iwlagn...
> Loading ath...
> Loading ar9170usb...
> Loading rtl8180...
> Loading rtl8187...
> Loading rt2400pci...
> Loading rt2500pci...
> Loading rt61pci...
> Loading rt2500usb...
> Loading rt73usb...
> Loading rndis_wlan...
> Loading at76_usb...
> FATAL: Module at76_usb not found.
> Loading mwl8k...
> Loading mac80211_hwsim...
> Loading at76c50x_usb...
> Loading bluetooth...
> Loading btusb...
> Loading l2cap...
> Loading sco...
> Loading hidp...
> Loading rfcomm...
> Loading bnep...
> Module ath_pci not detected -- this is fine
> ath5k loaded successfully
> ath9k loaded successfully
> Module bcm43xx not detected -- this is fine
> Disabling wl ...        [OK]    Module disabled:
> /lib/modules/2.6.30.9/kernel/net/wireless/wl.ko
> FATAL: Error inserting b43
> (/lib/modules/2.6.30.9/updates/drivers/net/wireless/b43/b43.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> b43 loaded successfully
> b43legacy loaded successfully
> Starting bluetooth service..
> Starting bluetooth: bluetoothd.
> bluetooth is running.
> root@bt:~/compat-wireless-2010-04-21# ifconfig
> eth0      Link encap:Ethernet  HWaddr 00:2a:4b:18:68:99
>           UP BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>           Interrupt:16
>
> lo        Link encap:Local Loopback
>           inet addr:127.0.0.1  Mask:255.0.0.0
>           inet6 addr: ::1/128 Scope:Host
>           UP LOOPBACK RUNNING  MTU:16436  Metric:1
>           RX packets:218 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:218 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:0
>           RX bytes:10928 (10.9 KB)  TX bytes:10928 (10.9 KB)
>
> wlan0     Link encap:Ethernet  HWaddr 02:01:20:00:60:00
>           UP BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>
> root@bt:~/compat-wireless-2010-04-21# iwconfig
> lo        no wireless extensions.
>
> eth0      no wireless extensions.
>
> wlan0     IEEE 802.11abgn  Mode:Managed  Access Point: Not-Associated
>           Tx-Power=20 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>
> wlan1     IEEE 802.11abgn  Mode:Managed  Access Point: Not-Associated
>           Tx-Power=0 dBm
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>
> hwsim0    no wireless extensions.
>
> pan0      no wireless extensions.
>
> root@bt:~/compat-wireless-2010-04-21# ifconfig wlan0 up
> root@bt:~/compat-wireless-2010-04-21# iwlist wlan0 scan
> wlan0     No scan results
>
> root@bt:~/compat-wireless-2010-04-21# iwlist wlan1 scan
> wlan1     Interface doesn't support scanning : Network is down
>
> root@bt:~/compat-wireless-2010-04-21# ifconfig wlan1 up
> root@bt:~/compat-wireless-2010-04-21# iwlist wlan1 scan
> wlan1     No scan results
> root@bt:~/compat-wireless-2010-04-21/scripts# ./wlload.sh
> Loading ipw2100...
> Loading ipw2200...
> Loading libertas_cs...
> Loading usb8xxx...
> Loading p54pci...
> Loading p54usb...
> Loading adm8211...
> Loading zd1211rw...
> Loading rtl8180...
> Loading rtl8187...
> Loading p54pci...
> Loading p54usb...
> Loading iwl3945...
> Loading iwlagn...
> Loading ath...
> Loading ar9170usb...
> Loading rtl8180...
> Loading rtl8187...
> Loading rt2400pci...
> Loading rt2500pci...
> Loading rt61pci...
> Loading rt2500usb...
> Loading rt73usb...
> Loading rndis_wlan...
> Loading at76_usb...
> FATAL: Module at76_usb not found.
> Loading mwl8k...
> Loading mac80211_hwsim...
> Loading at76c50x_usb...
> Module ath_pci not detected -- this is fine
> ath5k loaded successfully
> ath9k loaded successfully
> Module bcm43xx not detected -- this is fine
> Module wl not detected -- this is fine
> FATAL: Error inserting b43
> (/lib/modules/2.6.30.9/updates/drivers/net/wireless/b43/b43.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> b43 loaded successfully
> b43legacy loaded successfully
> root@bt:~/compat-wireless-2010-04-21# rebootbcm4311 can not be work
> after update comapt-wireless u nder bt4 final.
> Last edited by Archangel-Amael; Today at 02:49 PM.
>  Edit Post    Reply    Reply With Quote
> --------------------------------------------------------------------------------
> --
> Best Regards
> --------------------
> SECO
>
> --------------------------------------------------------------------------------
> This information in this e-mail is confidential and may well also be
> legally privileged. It is intended solely for the addressee. If you
> have received it in error, you are on notice of its status. Please
> notify us immediately and then destroy this message. Please do not
> copy it or use it for any purposes, or disclose its contents to any
> other person: to do so could be a breach of confidence. Thank you for
> your co-operation.
> --------------------------------------------------------------------------------
>


-- 
Best Regards
--------------------
SECO

--------------------------------------------------------------------------------
This information in this e-mail is confidential and may well also be
legally privileged. It is intended solely for the addressee. If you
have received it in error, you are on notice of its status. Please
notify us immediately and then destroy this message. Please do not
copy it or use it for any purposes, or disclose its contents to any
other person: to do so could be a breach of confidence. Thank you for
your co-operation.
--------------------------------------------------------------------------------

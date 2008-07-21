Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ro.mikronika.com.pl ([213.17.224.85]:50529 "EHLO
	cluster1.mikronika.com.pl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751916AbYGUNll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 09:41:41 -0400
Received: from [192.168.3.203] (szkudlarekk-lap.mikronika.com.pl [192.168.3.203])
	(authenticated bits=0)
	by cluster1.mikronika.com.pl (8.13.4/8.13.4) with ESMTP id m6LDTx5O000741
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 15:29:59 +0200
Message-ID: <48848F55.4060404@mikronika.com.pl> (sfid-20080721_154145_849082_1D240B38)
Date: Mon, 21 Jul 2008 15:29:57 +0200
From: Karol Szkudlarek <karol@mikronika.com.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwl3945
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I hope that report I'm sending to the right mailing list. During boot I=
=20
have a following crash in
mac80211 module. I'm using iwl3945 driver on my hp6710b laptop.

Jul 21 15:20:10 lap audio[5670]: Registered manager path:/org/bluez/aud=
io
Jul 21 15:20:10 lap kernel: [ 34.000991] WARNING: at=20
/home/karol/tmp/downloads/compat-wireless-2008-07-21/net/mac80211/util.=
c:385=20
ieee80211_wake_queue()
Jul 21 15:20:10 lap kernel: [ 34.001002] Pid: 3438, comm: iwl3945/0 Not=
=20
tainted 2.6.24-19-generic #1
Jul 21 15:20:10 lap kernel: [ 34.001025] [<f8c24ce7>]=20
ieee80211_wake_queue+0x87/0x90 [mac80211]
Jul 21 15:20:10 lap kernel: [ 34.001087] [<f8c24d0b>]=20
ieee80211_wake_queues+0x1b/0x30 [mac80211]
Jul 21 15:20:10 lap kernel: [ 34.001130] [<f8c4b0bc>]=20
iwl3945_bg_alive_start+0x1bc/0x340 [iwl3945]
Jul 21 15:20:10 lap kernel: [ 34.001158] [<f8c4af00>]=20
iwl3945_bg_alive_start+0x0/0x340 [iwl3945]
Jul 21 15:20:10 lap kernel: [ 34.001175] [run_workqueue+0xbf/0x160]=20
run_workqueue+0xbf/0x160
Jul 21 15:20:10 lap kernel: [ 34.001194] [worker_thread+0x0/0xe0]=20
worker_thread+0x0/0xe0
Jul 21 15:20:10 lap kernel: [ 34.001204] [worker_thread+0x84/0xe0]=20
worker_thread+0x84/0xe0
Jul 21 15:20:10 lap kernel: [ 34.001214] [<c0140c40>]=20
autoremove_wake_function+0x0/0x40
Jul 21 15:20:10 lap kernel: [ 34.001226] [worker_thread+0x0/0xe0]=20
worker_thread+0x0/0xe0
Jul 21 15:20:10 lap kernel: [ 34.001235] [kthread+0x42/0x70]=20
kthread+0x42/0x70
Jul 21 15:20:10 lap kernel: [ 34.001240] [kthread+0x0/0x70] kthread+0x0=
/0x70
Jul 21 15:20:10 lap kernel: [ 34.001249] [kernel_thread_helper+0x7/0x10=
]=20
kernel_thread_helper+0x7/0x10
Jul 21 15:20:10 lap kernel: [ 34.001265] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jul 21 15:20:10 lap kernel: [ 34.001269] WARNING: at=20
/home/karol/tmp/downloads/compat-wireless-2008-07-21/net/mac80211/util.=
c:385=20
ieee80211_wake_queue()
Jul 21 15:20:10 lap kernel: [ 34.001276] Pid: 3438, comm: iwl3945/0 Not=
=20
tainted 2.6.24-19-generic #1
Jul 21 15:20:10 lap kernel: [ 34.001283] [<f8c24ce7>]=20
ieee80211_wake_queue+0x87/0x90 [mac80211]
Jul 21 15:20:10 lap kernel: [ 34.001329] [<f8c24d0b>]=20
ieee80211_wake_queues+0x1b/0x30 [mac80211]
Jul 21 15:20:10 lap kernel: [ 34.001371] [<f8c4b0bc>]=20
iwl3945_bg_alive_start+0x1bc/0x340 [iwl3945]
Jul 21 15:20:10 lap kernel: [ 34.001397] [<f8c4af00>]=20
iwl3945_bg_alive_start+0x0/0x340 [iwl3945]
Jul 21 15:20:10 lap kernel: [ 34.001414] [run_workqueue+0xbf/0x160]=20
run_workqueue+0xbf/0x160
Jul 21 15:20:10 lap kernel: [ 34.001430] [worker_thread+0x0/0xe0]=20
worker_thread+0x0/0xe0
Jul 21 15:20:10 lap kernel: [ 34.001438] [worker_thread+0x84/0xe0]=20
worker_thread+0x84/0xe0
Jul 21 15:20:10 lap kernel: [ 34.001448] [<c0140c40>]=20
autoremove_wake_function+0x0/0x40
Jul 21 15:20:10 lap kernel: [ 34.001460] [worker_thread+0x0/0xe0]=20
worker_thread+0x0/0xe0
Jul 21 15:20:10 lap kernel: [ 34.001468] [kthread+0x42/0x70]=20
kthread+0x42/0x70
Jul 21 15:20:10 lap kernel: [ 34.001474] [kthread+0x0/0x70] kthread+0x0=
/0x70
Jul 21 15:20:10 lap kernel: [ 34.001483] [kernel_thread_helper+0x7/0x10=
]=20
kernel_thread_helper+0x7/0x10
Jul 21 15:20:10 lap kernel: [ 34.001496] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jul 21 15:20:10 lap kernel: [ 34.001500] WARNING: at=20
/home/karol/tmp/downloads/compat-wireless-2008-07-21/net/mac80211/util.=
c:385=20
ieee80211_wake_queue()
Jul 21 15:20:10 lap kernel: [ 34.001507] Pid: 3438, comm: iwl3945/0 Not=
=20
tainted 2.6.24-19-generic #1
Jul 21 15:20:10 lap kernel: [ 34.001514] [<f8c24ce7>]=20
ieee80211_wake_queue+0x87/0x90 [mac80211]
Jul 21 15:20:10 lap kernel: [ 34.001560] [<f8c24d0b>]=20
ieee80211_wake_queues+0x1b/0x30 [mac80211]
Jul 21 15:20:10 lap kernel: [ 34.001601] [<f8c4b0bc>]=20
iwl3945_bg_alive_start+0x1bc/0x340 [iwl3945]
Jul 21 15:20:10 lap kernel: [ 34.001626] [<f8c4af00>]=20
iwl3945_bg_alive_start+0x0/0x340 [iwl3945]
Jul 21 15:20:10 lap kernel: [ 34.001643] [run_workqueue+0xbf/0x160]=20
run_workqueue+0xbf/0x160
Jul 21 15:20:10 lap kernel: [ 34.001658] [worker_thread+0x0/0xe0]=20
worker_thread+0x0/0xe0
Jul 21 15:20:10 lap kernel: [ 34.001667] [worker_thread+0x84/0xe0]=20
worker_thread+0x84/0xe0
Jul 21 15:20:10 lap kernel: [ 34.001676] [<c0140c40>]=20
autoremove_wake_function+0x0/0x40
Jul 21 15:20:10 lap kernel: [ 34.001688] [worker_thread+0x0/0xe0]=20
worker_thread+0x0/0xe0
Jul 21 15:20:10 lap kernel: [ 34.001696] [kthread+0x42/0x70]=20
kthread+0x42/0x70
Jul 21 15:20:10 lap kernel: [ 34.001702] [kthread+0x0/0x70] kthread+0x0=
/0x70
Jul 21 15:20:10 lap kernel: [ 34.001710] [kernel_thread_helper+0x7/0x10=
]=20
kernel_thread_helper+0x7/0x10
Jul 21 15:20:10 lap kernel: [ 34.001724] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Jul 21 15:20:10 lap NetworkManager: <info> wlan0: Device is=20
fully-supported using driver 'iwl3945'.
Jul 21 15:20:10 lap NetworkManager: <info> wlan0: driver supports SSID=20
scans (scan_capa 0x01).
Jul 21 15:20:10 lap NetworkManager: <info> nm_device_init(): waiting fo=
r=20
device's worker thread to start
Jul 21 15:20:10 lap NetworkManager: <info> nm_device_init(): device's=20
worker thread started, continuing.
Jul 21 15:20:10 lap NetworkManager: <info> Now managing wireless=20
(802.11) device 'wlan0'.
Jul 21 15:20:10 lap NetworkManager: <info> Deactivating device wlan0.
Jul 21 15:20:10 lap NetworkManager: <info> Will activate wired=20
connection 'eth0' because it now has a link.
Jul 21 15:20:10 lap NetworkManager: <debug> [1216646410.600448]=20
nm_hal_device_added(): New device added (hal udi is=20
'/org/freedesktop/Hal/devices/storage_model_DVDRAM_GSA_T10N').
Jul 21 15:20:10 lap NetworkManager: <debug> [1216646410.601408]=20
nm_hal_device_added(): New device added (hal udi is=20
'/org/freedesktop/Hal/devices/platform_bluetooth').
Jul 21 15:20:10 lap NetworkManager: <info> Error getting killswitch=20
power: org.freedesktop.Hal.Device.KillSwitch.NotSupported -=20
hal-ipw-killswitch-linux returned 255
Jul 21 15:20:10 lap NetworkManager: <info> Wireless now enabled by radi=
o=20
killswitch
Jul 21 15:20:12 lap kernel: [ 34.619783] tg3: eth0: Link is up at 100=20
Mbps, full duplex.
Jul 21 15:20:12 lap kernel: [ 34.619791] tg3: eth0: Flow control is on=20
for TX and on for RX.
Jul 21 15:20:12 lap NetworkManager: <info> Will activate wired=20
connection 'eth0' because it now has a link.
Jul 21 15:20:12 lap NetworkManager: <info> SWITCH: no current=20
connection, found better connection 'eth0'.
Jul 21 15:20:12 lap dhcdbd: message_handler: message handler not found=20
under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.reason
Jul 21 15:20:12 lap NetworkManager: <info> Will activate connection 'et=
h0'.
Jul 21 15:20:12 lap NetworkManager: <info> Device eth0 activation=20
scheduled...


Linux lap 2.6.24-19-generic #1 SMP Fri Jul 11 23:41:49 UTC 2008 i686=20
GNU/Linux

Modules are built today from package:
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless=
-2.6.tar.bz2

--=20
Karol Szkudlarek
Mikronika
ul. Wykopy 2/4
60-001 POZNA=C3=91
tel. +48 61 6655600
fax +48 61 6655602
e-mail karol@mikronika.com.pl

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

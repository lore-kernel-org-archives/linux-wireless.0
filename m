Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:45441 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2HKMZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 08:25:38 -0400
Date: Sat, 11 Aug 2012 14:25:21 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Warning after suspend
Message-ID: <20120811122521.GK10376@ritirata.org> (sfid-20120811_142621_446797_484879DC)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jx/LfW4V5TfZLeq7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jx/LfW4V5TfZLeq7
Content-Type: multipart/mixed; boundary="7fwXp2o0gOrkU5lS"
Content-Disposition: inline


--7fwXp2o0gOrkU5lS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I attached the dmesg log I got after recovering from a suspend-to-disk. At =
the
beginning there is a strange behaviour that then led to a device reset (as =
far
as i understood) and immediately after I hit a warning in iwl-trans.h..
I am running linux-3.5.1 and this is the device I am using:

02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev=
 34)

I can test whatever patch, if needed.


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--7fwXp2o0gOrkU5lS
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="iwl-log.txt"
Content-Transfer-Encoding: quoted-printable

[51230.530727] iwlwifi 0000:02:00.0: Error sending POWER_TABLE_CMD: time ou=
t after 2000ms.
[51230.530740] iwlwifi 0000:02:00.0: Current CMD queue read_ptr 167 write_p=
tr 168
[51230.530750] iwlwifi 0000:02:00.0: set power fail, ret =3D -110
[51232.530152] iwlwifi 0000:02:00.0: fail to flush all tx fifo queues
[51232.530188] ieee80211 phy0: wlan0: Failed to send nullfunc to AP 00:24:8=
9:4d:23:1b after 500ms, disconnecting.
[51234.530595] iwlwifi 0000:02:00.0: Error sending REPLY_ADD_STA: time out =
after 2000ms.
[51234.530616] iwlwifi 0000:02:00.0: Current CMD queue read_ptr 167 write_p=
tr 169
[51234.530638] ieee80211 phy0: failed to remove key (0, 00:24:89:4d:23:1b) =
=66rom hardware (-110)
[51234.530922] wlan0: moving STA 00:24:89:4d:23:1b to state 3
[51234.530934] wlan0: moving STA 00:24:89:4d:23:1b to state 2
[51234.530941] wlan0: moving STA 00:24:89:4d:23:1b to state 1
[51234.532652] ieee80211 phy0: Removed STA 00:24:89:4d:23:1b
[51234.533320] ieee80211 phy0: Destroyed STA 00:24:89:4d:23:1b
[51236.530000] iwlwifi 0000:02:00.0: Error sending REPLY_QOS_PARAM: time ou=
t after 2000ms.
[51236.530021] iwlwifi 0000:02:00.0: Current CMD queue read_ptr 167 write_p=
tr 170
[51236.530035] iwlwifi 0000:02:00.0: Failed to update QoS
[51237.014524] iwlwifi 0000:02:00.0: Queue 2 stuck for 10000 ms.
[51237.014537] iwlwifi 0000:02:00.0: Current SW read_ptr 132 write_ptr 151
[51237.014629] iwlwifi 0000:02:00.0: Current HW read_ptr 151 write_ptr 151
[51237.014637] iwlwifi 0000:02:00.0: Loaded firmware version: 17.168.5.3 bu=
ild 42301
[51237.014818] iwlwifi 0000:02:00.0: 0x00000000 | OK                       =
  =20
[51237.014824] iwlwifi 0000:02:00.0: 0x00000000 | uPc
[51237.014830] iwlwifi 0000:02:00.0: 0x00000000 | branchlink1
[51237.014835] iwlwifi 0000:02:00.0: 0x00000000 | branchlink2
[51237.014841] iwlwifi 0000:02:00.0: 0x00000000 | interruptlink1
[51237.014846] iwlwifi 0000:02:00.0: 0x00000000 | interruptlink2
[51237.014851] iwlwifi 0000:02:00.0: 0x00000000 | data1
[51237.014856] iwlwifi 0000:02:00.0: 0x00000000 | data2
[51237.014861] iwlwifi 0000:02:00.0: 0x00000000 | line
[51237.014867] iwlwifi 0000:02:00.0: 0x00000000 | beacon time
[51237.014872] iwlwifi 0000:02:00.0: 0x00000000 | tsf low
[51237.014877] iwlwifi 0000:02:00.0: 0x00000000 | tsf hi
[51237.014882] iwlwifi 0000:02:00.0: 0x00000000 | time gp1
[51237.014888] iwlwifi 0000:02:00.0: 0x00000000 | time gp2
[51237.014893] iwlwifi 0000:02:00.0: 0x00000000 | time gp3
[51237.014898] iwlwifi 0000:02:00.0: 0x00000000 | uCode version
[51237.014903] iwlwifi 0000:02:00.0: 0x00000000 | hw version
[51237.014937] iwlwifi 0000:02:00.0: 0x00000000 | board version
[51237.014944] iwlwifi 0000:02:00.0: 0x00000000 | hcmd
[51237.014949] iwlwifi 0000:02:00.0: 0x00000000 | isr0
[51237.014954] iwlwifi 0000:02:00.0: 0x00000000 | isr1
[51237.014959] iwlwifi 0000:02:00.0: 0x00000000 | isr2
[51237.014965] iwlwifi 0000:02:00.0: 0x00000000 | isr3
[51237.014970] iwlwifi 0000:02:00.0: 0x00000000 | isr4
[51237.014975] iwlwifi 0000:02:00.0: 0x00000000 | isr_pref
[51237.014981] iwlwifi 0000:02:00.0: 0x00000000 | wait_event
[51237.014986] iwlwifi 0000:02:00.0: 0x00000000 | l2p_control
[51237.014991] iwlwifi 0000:02:00.0: 0x00000000 | l2p_duration
[51237.014997] iwlwifi 0000:02:00.0: 0x00000000 | l2p_mhvalid
[51237.015002] iwlwifi 0000:02:00.0: 0x00000000 | l2p_addr_match
[51237.015007] iwlwifi 0000:02:00.0: 0x00000000 | lmpm_pmg_sel
[51237.015013] iwlwifi 0000:02:00.0: 0x00000000 | timestamp
[51237.015018] iwlwifi 0000:02:00.0: 0x00000000 | flow_handler
[51237.015183] iwlwifi 0000:02:00.0: Start IWL Event Log Dump: display last=
 20 entries
[51237.015238] iwlwifi 0000:02:00.0: EVT_LOGT:3415258955:0x00002000:0350
[51237.015279] iwlwifi 0000:02:00.0: EVT_LOGT:3415258973:0x000000fa:0106
[51237.015318] iwlwifi 0000:02:00.0: EVT_LOGT:3415258974:0x00000000:0302
[51237.015357] iwlwifi 0000:02:00.0: EVT_LOGT:3415258987:0x00002000:0350
[51237.015397] iwlwifi 0000:02:00.0: EVT_LOGT:3415259300:0x000000fa:0106
[51237.015436] iwlwifi 0000:02:00.0: EVT_LOGT:3415259302:0x00000000:0302
[51237.015476] iwlwifi 0000:02:00.0: EVT_LOGT:3415259314:0x00002000:0350
[51237.015516] iwlwifi 0000:02:00.0: EVT_LOGT:3415259331:0x000000fa:0106
[51237.015556] iwlwifi 0000:02:00.0: EVT_LOGT:3415259333:0x00000000:0302
[51237.015595] iwlwifi 0000:02:00.0: EVT_LOGT:3415259345:0x00002000:0350
[51237.015634] iwlwifi 0000:02:00.0: EVT_LOGT:3415260434:0x000000fa:0106
[51237.015674] iwlwifi 0000:02:00.0: EVT_LOGT:3415260435:0x00000000:0302
[51237.015714] iwlwifi 0000:02:00.0: EVT_LOGT:3415260448:0x00002000:0350
[51237.015753] iwlwifi 0000:02:00.0: EVT_LOGT:3415260729:0x000000fa:0106
[51237.015793] iwlwifi 0000:02:00.0: EVT_LOGT:3415260730:0x00000000:0301
[51237.015833] iwlwifi 0000:02:00.0: EVT_LOGT:3415261117:0x000000fa:0106
[51237.015872] iwlwifi 0000:02:00.0: EVT_LOGT:3415261119:0x00000000:0301
[51237.015912] iwlwifi 0000:02:00.0: EVT_LOGT:3415261213:0x00000000:0301
[51237.015951] iwlwifi 0000:02:00.0: EVT_LOGT:3415261379:0x00000000:0301
[51237.015990] iwlwifi 0000:02:00.0: EVT_LOGT:3415261548:0x00000000:0301
[51238.527414] iwlwifi 0000:02:00.0: Error sending REPLY_RXON: time out aft=
er 2000ms.
[51238.527453] iwlwifi 0000:02:00.0: Current CMD queue read_ptr 167 write_p=
tr 171
[51238.527468] iwlwifi 0000:02:00.0: Error clearing ASSOC_MSK on BSS (-110)
[51238.529969] ieee80211 phy0: Hardware restart was requested
[51238.531735] ieee80211 phy0: device now idle
[51238.531749] ------------[ cut here ]------------
[51238.531784] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans.h:565 iwl=
agn_mac_flush+0x1a3/0x1b0 [iwlwifi]()
[51238.531793] Hardware name: Latitude E5420
[51238.531801] iwl_trans_wait_tx_queue_empty bad state =3D 0
[51238.531808] Modules linked in: uvcvideo videobuf2_vmalloc videobuf2_memo=
ps videobuf2_core videodev tun bridge stp llc bluetooth ppp_async crc_ccitt=
 ppp_generic slhc cpufreq_powersave trelay(O) cpufreq_stats phc_intel(O) mp=
erf iwlwifi mac80211 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd=
_hda_codec kvm_intel kvm snd_hwdep cfg80211 snd_pcm snd_page_alloc ehci_hcd=
 snd_timer snd usbcore crc32c_intel aesni_intel lpc_ich psmouse aes_x86_64 =
cryptd usb_common mfd_core soundcore [last unloaded: bluetooth]
[51238.532031] Pid: 11731, comm: kworker/u:2 Tainted: G        W  O 3.5.1-o=
rdex+ #13
[51238.532038] Call Trace:
[51238.532071]  [<ffffffff810397af>] warn_slowpath_common+0x7f/0xc0
[51238.532088]  [<ffffffff810398a6>] warn_slowpath_fmt+0x46/0x50
[51238.532141]  [<ffffffffa02b0263>] iwlagn_mac_flush+0x1a3/0x1b0 [iwlwifi]
[51238.532197]  [<ffffffffa0174b83>] __ieee80211_recalc_idle+0x393/0x5d0 [m=
ac80211]
[51238.532248]  [<ffffffffa0177215>] ieee80211_recalc_idle+0x35/0x60 [mac80=
211]
[51238.532311]  [<ffffffffa01a83d3>] ieee80211_sta_connection_lost.isra.20+=
0x73/0xa0 [mac80211]
[51238.532420]  [<ffffffffa01ac387>] ieee80211_sta_work+0x787/0xce0 [mac802=
11]
[51238.532437]  [<ffffffff8159313c>] ? _raw_spin_lock_irqsave+0x1c/0x60
[51238.532451]  [<ffffffff815938c5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[51238.532509]  [<ffffffffa0173240>] ? ieee80211_teardown_sdata+0xf0/0xf0 [=
mac80211]
[51238.532536]  [<ffffffff81074ff9>] ? sub_preempt_count+0xa9/0xe0
[51238.532593]  [<ffffffffa0173240>] ? ieee80211_teardown_sdata+0xf0/0xf0 [=
mac80211]
[51238.532653]  [<ffffffffa0173508>] ieee80211_iface_work+0x2c8/0x360 [mac8=
0211]
[51238.532703]  [<ffffffffa0173240>] ? ieee80211_teardown_sdata+0xf0/0xf0 [=
mac80211]
[51238.532720]  [<ffffffff8105d344>] process_one_work+0x184/0x6e0
[51238.532735]  [<ffffffff8105d2da>] ? process_one_work+0x11a/0x6e0
[51238.532749]  [<ffffffff815930e7>] ? _raw_spin_lock_irq+0x17/0x50
[51238.532784]  [<ffffffff8105dc7f>] worker_thread+0x15f/0x350
[51238.532800]  [<ffffffff8105db20>] ? rescuer_thread+0x240/0x240
[51238.532815]  [<ffffffff810630c3>] kthread+0x93/0xa0
[51238.532832]  [<ffffffff81595814>] kernel_thread_helper+0x4/0x10
[51238.532848]  [<ffffffff8106f765>] ? finish_task_switch+0x85/0x110
[51238.532862]  [<ffffffff8159383b>] ? _raw_spin_unlock_irq+0x3b/0x60
[51238.532876]  [<ffffffff81593d5d>] ? retint_restore_args+0xe/0xe
[51238.532891]  [<ffffffff81063030>] ? __init_kthread_worker+0x70/0x70
[51238.532906]  [<ffffffff81595810>] ? gs_change+0xb/0xb
[51238.532915] ---[ end trace e93713a9d40cd06e ]---


--7fwXp2o0gOrkU5lS--

--jx/LfW4V5TfZLeq7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlAmTzEACgkQpGgxIkP9cwcnbQCePN3t8lr0mEk3KwFIIGrgO6YL
wOsAnirUSdU7oAto64dac/UjJCXHmCqx
=OQKE
-----END PGP SIGNATURE-----

--jx/LfW4V5TfZLeq7--

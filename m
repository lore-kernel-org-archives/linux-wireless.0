Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:43807
	"EHLO qmta01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671Ab1K2QoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 11:44:11 -0500
Received: from www.jots.org (unknown [192.168.22.1])
	by elanor.jots.org (Postfix) with ESMTP id B6ED84000A
	for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 11:37:54 -0500 (EST)
To: <linux-wireless@vger.kernel.org>
In-Reply-To: <a562bb7bd5c895756114c38e0de891de@www.jots.org>
References: <a562bb7bd5c895756114c38e0de891de@www.jots.org>
From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: Followup with dmesg WARNING (was Bug report: can't maintain WiFi
        connectivity in recent kernels.)
Date: Tue, 29 Nov 2011 11:37:54 -0500
Content-Type: text/plain; charset=UTF-8; format=fixed
MIME-Version: 1.0
Message-id: <c0a90b062722776c7489fddc7af180bd@www.jots.org> (sfid-20111129_174415_668604_902B0D52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Second followup: just died again, but with a different dmesg error:

[ 7948.686417] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7948.686544] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7948.686591] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7948.687146] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7948.717489] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7948.717800] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7977.691091] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7977.691229] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7977.691277] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7977.691319] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7977.691359] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7977.691903] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7977.739840] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 7977.740126] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable
buffer
[ 8662.475775] wlan0: deauthenticated from 18:ef:63:58:a4:c1 (Reason: 1)
[ 8662.483725] iwlwifi 0000:02:00.0: Stopping AGG while state not ON or
starting for 0 on 0 (0)
[ 8662.496485] cfg80211: All devices are disconnected, going to restore
regulatory settings
[ 8662.496493] cfg80211: Restoring regulatory settings
[ 8662.496500] cfg80211: Calling CRDA to update world regulatory domain
[ 8662.500873] cfg80211: Ignoring regulatory request Set by core since the
driver uses its own custom regulatory domain
[ 8662.500880] cfg80211: World regulatory domain updated:
[ 8662.500883] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 8662.500889] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 8662.500894] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[ 8662.500899] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[ 8662.500903] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 8662.500908] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 8662.900200] wlan0: authenticate with 18:ef:63:58:a4:c1 (try 1)
[ 8662.903621] wlan0: authenticated
[ 8662.903716] wlan0: waiting for beacon from 18:ef:63:58:a4:c1
[ 8662.977778] wlan0: beacon received
[ 8663.025447] wlan0: associate with 18:ef:63:58:a4:c1 (try 1)
[ 8663.028790] wlan0: RX AssocResp from 18:ef:63:58:a4:c1 (capab=0x421
status=17 aid=0)
[ 8663.028796] wlan0: 18:ef:63:58:a4:c1 denied association (code=17)
[ 8663.076089] wlan0: deauthenticating from 18:ef:63:58:a4:c1 by local choice
(reason=3)
[ 8673.259431] wlan0: authenticate with 00:27:0d:98:d1:f1 (try 1)
[ 8673.259472] wlan0: deauthenticating from 00:27:0d:98:d1:f1 by local choice
(reason=3)
[ 8688.305183] iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting
0x2000000.
[ 8688.305192] iwlwifi 0000:02:00.0: Loaded firmware version: 128.50.3.1 build
13488
[ 8688.305308] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
[ 8688.305314] iwlwifi 0000:02:00.0: Status: 0x0004B2E5, count: 5
[ 8688.305321] iwlwifi 0000:02:00.0: 0x00000005 | SYSASSERT                   
[ 8688.305327] iwlwifi 0000:02:00.0: 0x000133F8 | uPc
[ 8688.305331] iwlwifi 0000:02:00.0: 0x000133D6 | branchlink1
[ 8688.305337] iwlwifi 0000:02:00.0: 0x000133D6 | branchlink2
[ 8688.305342] iwlwifi 0000:02:00.0: 0x00000892 | interruptlink1
[ 8688.305347] iwlwifi 0000:02:00.0: 0x00000000 | interruptlink2
[ 8688.305353] iwlwifi 0000:02:00.0: 0x24020080 | data1
[ 8688.305358] iwlwifi 0000:02:00.0: 0x00000000 | data2
[ 8688.305363] iwlwifi 0000:02:00.0: 0x00000072 | line
[ 8688.305368] iwlwifi 0000:02:00.0: 0x00018C25 | beacon time
[ 8688.305373] iwlwifi 0000:02:00.0: 0x000003DB | tsf low
[ 8688.305378] iwlwifi 0000:02:00.0: 0x00000000 | tsf hi
[ 8688.305383] iwlwifi 0000:02:00.0: 0x00000000 | time gp1
[ 8688.305388] iwlwifi 0000:02:00.0: 0xE09B27CE | time gp2
[ 8688.305394] iwlwifi 0000:02:00.0: 0x00000000 | time gp3
[ 8688.305399] iwlwifi 0000:02:00.0: 0x00018032 | uCode version
[ 8688.305404] iwlwifi 0000:02:00.0: 0x00000000 | hw version
[ 8688.305409] iwlwifi 0000:02:00.0: 0x00880300 | board version
[ 8688.305415] iwlwifi 0000:02:00.0: 0x04670077 | hcmd
[ 8688.305420] iwlwifi 0000:02:00.0: CSR values:
[ 8688.305424] iwlwifi 0000:02:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[ 8688.305453] iwlwifi 0000:02:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[ 8688.305480] iwlwifi 0000:02:00.0:          CSR_INT_COALESCING: 0X0000ff40
[ 8688.305506] iwlwifi 0000:02:00.0:                     CSR_INT: 0X00000000
[ 8688.305533] iwlwifi 0000:02:00.0:                CSR_INT_MASK: 0X00000000
[ 8688.305559] iwlwifi 0000:02:00.0:           CSR_FH_INT_STATUS: 0X00000000
[ 8688.305586] iwlwifi 0000:02:00.0:                 CSR_GPIO_IN: 0X00000000
[ 8688.305612] iwlwifi 0000:02:00.0:                   CSR_RESET: 0X00000000
[ 8688.305640] iwlwifi 0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
[ 8688.305666] iwlwifi 0000:02:00.0:                  CSR_HW_REV: 0X0000006c
[ 8688.305693] iwlwifi 0000:02:00.0:              CSR_EEPROM_REG: 0X007708e5
[ 8688.305719] iwlwifi 0000:02:00.0:               CSR_EEPROM_GP: 0X90000001
[ 8688.305746] iwlwifi 0000:02:00.0:              CSR_OTP_GP_REG: 0X00010001
[ 8688.305773] iwlwifi 0000:02:00.0:                 CSR_GIO_REG: 0X00080042
[ 8688.305800] iwlwifi 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00004467
[ 8688.305826] iwlwifi 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[ 8688.305773] iwlwifi 0000:02:00.0:                 CSR_GIO_REG: 0X00080042
[ 8688.305800] iwlwifi 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00004467
[ 8688.305826] iwlwifi 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[ 8688.305852] iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP1: 0X00000001
[ 8688.305879] iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[ 8688.305906] iwlwifi 0000:02:00.0:                 CSR_LED_REG: 0X00000058
[ 8688.305932] iwlwifi 0000:02:00.0:        CSR_DRAM_INT_TBL_REG: 0X88031f98
[ 8688.305959] iwlwifi 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[ 8688.305985] iwlwifi 0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00880300
[ 8688.306012] iwlwifi 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[ 8688.306039] iwlwifi 0000:02:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[ 8688.306043] iwlwifi 0000:02:00.0: FH register values:
[ 8688.306086] iwlwifi 0000:02:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG:
0X02fbfd00
[ 8688.306124] iwlwifi 0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG:
0X002cd1e0
[ 8688.306161] iwlwifi 0000:02:00.0:                  FH_RSCSR_CHNL0_WPTR:
0X000000c8
[ 8688.306197] iwlwifi 0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG:
0X80819104
[ 8688.306234] iwlwifi 0000:02:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG:
0X000000fc
[ 8688.306272] iwlwifi 0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG:
0X07030000
[ 8688.306307] iwlwifi 0000:02:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
0X00000000
[ 8688.306349] iwlwifi 0000:02:00.0:                FH_TSSR_TX_STATUS_REG:
0X077f0001
[ 8688.306384] iwlwifi 0000:02:00.0:                 FH_TSSR_TX_ERROR_REG:
0X00000000
[ 8688.306467] iwlwifi 0000:02:00.0: Start IWL Event Log Dump: nothing in log
[ 8688.306840] iwlwifi 0000:02:00.0: Command REPLY_SCAN_CMD failed: FW Error
[ 8688.309152] iwlwifi 0000:02:00.0: Failing on timeout while stopping DMA
channel 7 [0x077f0001]
[ 8688.312109] ieee80211 phy1: Hardware restart was requested
[ 8688.312189] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S



On Tue, 29 Nov 2011 09:18:40 -0500 "Ken D'Ambrosio" <ken@jots.org> wrote

> I hadn't sent this, because I'd thought I was only getting WARNINGs on my
> Virtualbox-tainted kernel, but this happened untainted, so here you go.  Hope
> it helps!
> 

> -Ken
> 
> 
> [  198.113130] wlan0: deauthenticating from 00:27:0d:98:d1:f1 by local choice
> (reason=3)
> [  198.113277] ------------[ cut here ]------------
> [  198.113313] WARNING: at net/wireless/mlme.c:309
> __cfg80211_auth_remove+0x56/0xa0 [cfg80211]()
> [  198.113317] Hardware name: EC14 Series
> [  198.113320] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat
> binfmt_misc ppdev snd_hda_codec_hdmi snd_hda_codec_realtek joydev
> snd_hda_intel snd_hda_codec arc4 snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
> usb_storage snd_seq_dummy uvcvideo videodev snd_seq_oss fbcon tileblit
> snd_seq_midi i915 snd_rawmidi iwlwifi font bitblit snd_seq_midi_event
> softcursor snd_seq psmouse snd_timer snd_seq_device serio_raw mac80211
> drm_kms_helper acer_wmi drm sparse_keymap atl1c i2c_algo_bit cfg80211
> intel_agp snd intel_gtt agpgart soundcore video snd_page_alloc lp parport
> [  198.113397] Pid: 44, comm: kworker/u:3 Not tainted 3.1.0+ #1
> [  198.113401] Call Trace:
> [  198.113412]  [<c068e057>] ? printk+0x1d/0x1f
> [  198.113423]  [<c01562b2>] warn_slowpath_common+0x72/0xa0
> [  198.113439]  [<f8cbc1e6>] ? __cfg80211_auth_remove+0x56/0xa0 [cfg80211]
> [  198.113454]  [<f8cbc1e6>] ? __cfg80211_auth_remove+0x56/0xa0 [cfg80211]
> [  198.113461]  [<c0156302>] warn_slowpath_null+0x22/0x30
> [  198.113480]  [<f8cbc1e6>] __cfg80211_auth_remove+0x56/0xa0 [cfg80211]
> [  198.113496]  [<f8cbc2ae>] cfg80211_send_auth_timeout+0x5e/0xc0 [cfg80211]
> [  198.113518]  [<f868f796>] ieee80211_probe_auth_done+0xe6/0xf0 [mac80211]
> [  198.113525]  [<c014f614>] ? wake_up_process+0x14/0x20
> [  198.113532]  [<c06976ec>] ? __mutex_unlock_slowpath+0x3c/0x50
> [  198.113552]  [<f86929bb>] ieee80211_work_work+0x47b/0x12d0 [mac80211]
> [  198.113559]  [<c0134c58>] ? default_spin_lock_flags+0x8/0x10
> [  198.113566]  [<c0698701>] ? _raw_spin_trylock_bh+0x1/0x30
> [  198.113575]  [<c017043e>] process_one_work+0xfe/0x3a0
> [  198.113580]  [<c014f614>] ? wake_up_process+0x14/0x20
> [  198.113586]  [<c016dfe5>] ? start_worker+0x25/0x30
> [  198.113605]  [<f8692540>] ? free_work+0x20/0x20 [mac80211]
> [  198.113612]  [<c0170f74>] worker_thread+0x124/0x2d0
> [  198.113618]  [<c0170e50>] ? manage_workers.isra.28+0x1e0/0x1e0
> [  198.113624]  [<c0174ced>] kthread+0x6d/0x80
> [  198.113630]  [<c0174c80>] ? flush_kthread_worker+0x80/0x80
> [  198.113637]  [<c069fb06>] kernel_thread_helper+0x6/0x10
> [  198.113642] ---[ end trace 04bdbdc199f6d75f ]---
> 
> 
> 
> Hi.  For reasons pertaining to btrfs, I'm running 3.1+  kernels, and the wifi
> on my system now flakes out sporadically, but reliably.  It can sometimes run
> for a couple days, but other days (like, say, yesterday) it'll fail upwards
> of 30 times. Simply attempting to re-acquire a connection via Network Manager
> fails 100%.  I need to rmmod and modprobe the iwlwifi module, and then am
> able to immediately connect, 100% of the time -- albeit, briefly.  Rebooting
> under these circumstances seems to have as much affect as reloading the
> module.  (I wonder if there's something that changes on the WAP side that
> triggers this?  That would explain the occasional doses of extended uptime,
> followed by days of misery, regardless of reboots and module playing.)
> 
> While the behavior, sadly, *is* sporadic, when
> 
> - it's not a problem on older (distribution-supplied) kernels, and
> - reloading -- and only reloading -- the module fixes it, however briefly,
> 
> it seems to me it's probably a problem with the module.
> 
> 
> Here's some additional information:
> 
> * Happens on multiple WAPs (home, hotel, work, etc.)
> 
> * 02:00.0 Network controller: Intel Corporation WiFi Link 1000 Series
> 
> * The system *thinks* everything is fine -- NetworkManager happily shows all
> the WAPs, etc. -- but I'm unable to re-acquire them until I reload the
> module. 
>
> * kernel 3.1.0+, untainted  (Chris Mason's btrfs git pull from three weeks
> ago; also experienced with slightly older, post 3.x kernels)
> 
> * Seems to fail most quickly under load (e.g., streaming); can push an hour
> if doing relatively little
> 
> * I'm unsure which kernel rev. was the tipping point, but Ubuntu 10.04
> generally "just worked," and is what I'm booted to now off of USB -- 2.6.32.
> 
> I'd give you dmesg messages, but I'm -- catch-22 -- Ubuntu 10.04 won't mount
> my btrfs partition, but runs WiFi flawlessly.  If you need those messages,
> just let me know, and I'll pull them off.
> 
> If there's anything else I can help out with, please don't hesitate to let me
> know.
> 
> Thanks!
> 
> -Ken






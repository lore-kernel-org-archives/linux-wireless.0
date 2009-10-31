Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:63190 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746AbZJaN04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 09:26:56 -0400
Received: by iwn10 with SMTP id 10so2708814iwn.4
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 06:27:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <167ae39b0910310615k5475e5cp55d1c0d60e7a443b@mail.gmail.com>
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com>
	<4ACE131E.3080908@lwfinger.net> <43e72e890910271137l31082c41t7e62a82e901d3456@mail.gmail.com>
	<167ae39b0910310615k5475e5cp55d1c0d60e7a443b@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 31 Oct 2009 06:26:41 -0700
Message-ID: <43e72e890910310626q6d145673he38a3a4e56ca8f7c@mail.gmail.com>
Subject: Re: Prism54/p54pci
To: James Grossmann <cctsurf@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Christian Lamparter <chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please keep the CC list here. This type of report is rare and we need
it archived. Please try using wireless-testing or compat-wireless:

http://wireless.kernel.org/en/users/Download

  Luis

On Sat, Oct 31, 2009 at 6:15 AM, James Grossmann <cctsurf@gmail.com> wrote:
> Attempted under Ubuntu 9.10, using their kernel 2.6.31-14-generic.
> Unfortunately it still does not work, is it possible to load the
> fullmac firmware through p54pci?  just a thought...
> Here's my relevant dmesg:
> [   15.369250] pcmcia_socket pcmcia_socket0: cs: IO port probe
> 0x100-0x3af: clean.
> [   15.370157] pcmcia_socket pcmcia_socket0: cs: IO port probe
> 0x3e0-0x4ff: excluding 0x4d0-0x4d7
> [   15.370585] pcmcia_socket pcmcia_socket0: cs: IO port probe
> 0x820-0x8ff: clean.
> [   15.370956] pcmcia_socket pcmcia_socket0: cs: IO port probe
> 0xc00-0xcf7: clean.
> [   15.371596] pcmcia_socket pcmcia_socket0: cs: IO port probe
> 0xa00-0xaff: clean.
> [   15.776624] p54pci 0000:03:00.0: enabling device (0000 -> 0002)
> [   15.776653] p54pci 0000:03:00.0: PCI INT A -> Link[LNKA] -> GSI 11
> (level, low) -> IRQ 11
> [   15.776675] p54pci 0000:03:00.0: setting latency timer to 64
> [   15.776789] p54pci 0000:03:00.0: firmware: requesting isl3886pci
> [   15.916240] cfg80211: World regulatory domain updated:
> [   15.916252]  (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [   15.916260]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [   15.916267]  (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [   15.916274]  (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [   15.916280]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [   15.916287]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [   16.048573] phy0: p54 detected a LM86 firmware
> [   16.048582] p54: rx_mtu reduced from 3240 to 2376
> [   16.048588] phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
> [   16.048594] phy0: cryptographic accelerator WEP:YES, TKIP:YES,
> CCMP:YES
> [   16.328427] Intel ICH 0000:00:1f.5: enabling device (0000 -> 0001)
> [   16.328448] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI
> 11 (level, low) -> IRQ 11
> [   16.328477] Intel ICH 0000:00:1f.5: setting latency timer to 64
> [   16.917291] phy0: hwaddr 00:xx:xx:xx:xx:xx, MAC:isl3880 RF:Frisbee
> [   17.140101] intel8x0_measure_ac97_clock: measured 52127 usecs (2506
> samples)
> [   17.140111] intel8x0: clocking to 48000
> [   17.265086] phy0: Selected rate control algorithm 'minstrel'
> [   17.266862] Registered led device: p54-phy0::assoc
> [   17.266906] Registered led device: p54-phy0::tx
> [   17.266951] Registered led device: p54-phy0::rx
> [   17.266992] Registered led device: p54-phy0::radio
> [   17.267007] p54pci 0000:03:00.0: is registered as 'phy0'
> [   17.292918] udev: renamed network interface wlan0 to wlan1
> [   30.512797] EXT3 FS on sda5, internal journal
> [   31.876640] kjournald starting.  Commit interval 5 seconds
> [   31.876989] EXT3 FS on sda7, internal journal
> [   31.877000] EXT3-fs: mounted filesystem with writeback data mode.
> [   32.829400] type=1505 audit(1256993753.257:9):
> operation="profile_replace" pid=853 name=/sbin/dhclient3
> [   32.830401] type=1505 audit(1256993753.257:10):
> operation="profile_replace" pid=853
> name=/usr/lib/NetworkManager/nm-dhcp-client.action
> [   32.830965] type=1505 audit(1256993753.257:11):
> operation="profile_replace" pid=853
> name=/usr/lib/connman/scripts/dhclient-script
> [   32.837982] type=1505 audit(1256993753.265:12):
> operation="profile_replace" pid=855
> name=/usr/lib/cups/backend/cups-pdf
> [   32.839224] type=1505 audit(1256993753.265:13):
> operation="profile_replace" pid=855 name=/usr/sbin/cupsd
> [   32.844175] type=1505 audit(1256993753.273:14):
> operation="profile_replace" pid=856 name=/usr/sbin/mysqld-akonadi
> [   32.847992] type=1505 audit(1256993753.273:15):
> operation="profile_replace" pid=857 name=/usr/sbin/tcpdump
> [   37.182116] RPC: Registered udp transport module.
> [   37.182124] RPC: Registered tcp transport module.
> [   37.410106] Installing knfsd (copyright (C) 1996
> okir@monad.swb.de).
> [   40.921453] svc: failed to register lockdv1 RPC service (errno 97).
> [   40.923471] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
> recovery directory
> [   40.988229] NFSD: starting 90-second grace period
> [   41.914184] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [   41.938395] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   42.970111] [drm] Initialized drm 1.1.0 20060810
> [   42.978943] pci 0000:01:00.0: power state changed by ACPI to D0
> [   42.978965] pci 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 11
> (level, low) -> IRQ 11
> [   42.979601] [drm] Initialized savage 2.4.1 20050313 for
> 0000:01:00.0 on minor 0
> [   43.052134] phy0: frequency change failed
> [   43.052155] phy0: frequency change failed
> [   43.052163] phy0: frequency change failed
> [   43.052170] phy0: frequency change failed
> [   43.052177] phy0: frequency change failed
> [   43.116051] phy0: frequency change failed
> [   43.116070] phy0: frequency change failed
> [   43.116077] phy0: frequency change failed
> [   43.116085] phy0: frequency change failed
> [   43.116092] phy0: frequency change failed
> [   63.664124] phy0: frequency change failed
> [   63.664154] phy0: frequency change failed
> [   63.664162] phy0: frequency change failed
> [   63.664170] phy0: frequency change failed
> [   63.664177] phy0: frequency change failed
> [   63.724148] phy0: frequency change failed
> [   63.724174] phy0: frequency change failed
> [   63.724182] phy0: frequency change failed
> [   63.724189] phy0: frequency change failed
> [   63.724197] phy0: frequency change failed
> [   69.288818] ondemand governor failed, too long transition latency
> of HW, fallback to performance governor
> [   93.668072] phy0: frequency change failed
> [   93.668093] phy0: frequency change failed
> [   93.668101] phy0: frequency change failed
> [   93.668108] phy0: frequency change failed
> [   93.668115] phy0: frequency change failed
> [   93.724065] phy0: frequency change failed
> [   93.724086] phy0: frequency change failed
> [   93.724094] phy0: frequency change failed
> [   93.724101] phy0: frequency change failed
> [   93.724108] phy0: frequency change failed
> [  109.068537] ondemand governor failed, too long transition latency
> of HW, fallback to performance governor
> [  115.912103] phy0: frequency change failed
> [  115.912120] phy0: frequency change failed
> [  115.912128] phy0: frequency change failed
> [  115.912135] phy0: frequency change failed
> [  115.912142] phy0: frequency change failed
> [  115.968099] phy0: frequency change failed
> [  115.968112] phy0: frequency change failed
> [  115.968120] phy0: frequency change failed
> [  115.968127] phy0: frequency change failed
> [  115.968134] phy0: frequency change failed
> [  116.368824] phy0: frequency change failed
> [  116.371618] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx try 1
> [  116.568114] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx try 2
> [  116.769380] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx try 3
> [  116.968120] wlan1: direct probe to AP 00:xx:xx:xx:xx:xx timed out
> [  121.456176] phy0: frequency change failed
> [  121.456193] phy0: frequency change failed
> [  121.456201] phy0: frequency change failed
> [  121.456208] phy0: frequency change failed
> [  121.456215] phy0: frequency change failed
> [  121.512156] phy0: frequency change failed
> [  121.512169] phy0: frequency change failed
> [  121.512177] phy0: frequency change failed
> [  121.512184] phy0: frequency change failed
> [  121.512191] phy0: frequency change failed
> [  121.912200] phy0: frequency change failed
> [  121.915107] wlan1: authenticate with AP 00:xx:xx:xx:xx:xx
> [  122.112177] wlan1: authenticate with AP 00:xx:xx:xx:xx:xx
> [  122.312156] wlan1: authenticate with AP 00:xx:xx:xx:xx:xx
> [  122.512154] wlan1: authentication with AP 00:xx:xx:xx:xx:xx timed
> out
> [  127.000168] phy0: frequency change failed
> [  127.000184] phy0: frequency change failed
> [  127.000192] phy0: frequency change failed
> [  127.000199] phy0: frequency change failed
> [  127.000206] phy0: frequency change failed
> [  127.056164] phy0: frequency change failed
> [  127.056173] phy0: frequency change failed
> [  127.056181] phy0: frequency change failed
> [  127.056188] phy0: frequency change failed
> [  127.056195] phy0: frequency change failed
> [  127.460382] phy0: frequency change failed
>
> and it continues like that until I remove the module.
>
>
> On Tue, Oct 27, 2009 at 1:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Thu, Oct 8, 2009 at 9:28 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> On 10/07/2009 04:00 PM, James Grossmann wrote:
>>>>
>>>> I have the gigafast WF728-AEX, which doesn't seem to work with the
>>>> p54pci drivers, I was previously using it with my Thinkpad T23 under
>>>> Gentoo (gentoo kernels 2.6.29 and 2.6.30), and could only use the
>>>> 1.0.4.3 firmware, now, I am using it under Ubuntu 9.04
>>>> (2.6.28-15-generic kernel) on the same computer, and find that I have
>>>> to load the prism54 driver to make it work.
>>>> I noticed that you were considering this to be depricated, I hope that
>>>> you can help me to make p54pci work!
>>>
>>> As it works with 2.6.29 and 2.6.30 kernels, but not with 2.6.28, it seems
>>> likely that you need a later version of the driver. Does Ubuntu have a
>>> package for compat-wireless? If so, install it. If not, you will need to
>>> install from source.
>>
>> James, please do test with a new driver and appropriate firmware and
>> let us know if it worked or not.
>>
>>  Luis
>>
>

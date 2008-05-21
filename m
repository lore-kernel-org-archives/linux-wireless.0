Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:60076 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979AbYEUGhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 02:37:38 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2077282wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 23:37:37 -0700 (PDT)
Message-ID: <c785bba30805202337r5d2ea27fp1e102cd233b549d6@mail.gmail.com> (sfid-20080521_083746_801971_BE38D4C1)
Date: Tue, 20 May 2008 23:37:37 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: newbie rtl8187 question
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1211333092.11738.18.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c785bba30805132014y56aafa7bi8788503f67a7c809@mail.gmail.com>
	 <1210736718.2721.4.camel@rd>
	 <c785bba30805132050y51cc3031uae718bc74ade96@mail.gmail.com>
	 <1210737929.2721.19.camel@rd>
	 <c785bba30805132141l62bef2d7n4d78a95510ed6a3d@mail.gmail.com>
	 <1210740748.2721.62.camel@rd>
	 <c785bba30805172315q42066fct39e20b35629faa51@mail.gmail.com>
	 <1211333092.11738.18.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the response. I was only able to add the first block to
rtl8187_dev.c. Here is the output.

thanks,
Paul

linuxstamp:~# skb_under_panic: text:c01ae2c4 len:74 put:32
head:c1ed0000 data:c1ecfffc tail:0xc1ed0046 end:0xc1ed0120
dev:wmaster0
kernel BUG at net/core/skbuff.c:149!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.26-rc2-wl-dirty #5)
PC is at __bug+0x20/0x2c
LR is at vprintk+0x304/0x344
pc : [<c00255a8>]    lr : [<c0038ab8>]    psr: 20000013
sp : c1db1d30  ip : c1db1c94  fp : c1db1d3c
r10: c1ed24a0  r9 : c1db1e38  r8 : 0000802a
r7 : c1ed0120  r6 : c1ed0046  r5 : c1ecfffc  r4 : c1ed0000
r3 : 00000000  r2 : 00000102  r1 : 00000001  r0 : 00000028
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: 21d98000  DAC: 00000017
Process rtl8187 (pid: 1226, stack limit = 0xc1db0260)
Stack: (0xc1db1d30 to 0xc1db2000)
1d20:                                     c1db1d70 c1db1d40 c020ee74 c0025598
1d40: c1ed0000 c1ecfffc c1ed0046 c1ed0120 c1e02800 00000020 c1ed24a0 023a0000
1d60: 00000001 c1db1d88 c1db1d74 c020fd04 c020ee28 c1db1e00 00000001 c1db1ddc
1d80: c1db1d8c c01ae2c4 c020fcd8 00000001 00000000 c1d399e0 c1db8160 c1db9300
1da0: c1db8160 00000006 00000007 00000005 00000004 c1db1e00 c1db1e38 c1db8160
1dc0: c1ed24a0 c1db8160 c1db1e38 c1e02000 c1db1dfc c1db1de0 c02a9d94 c01ae0c8
1de0: c0374894 c1db0000 00000000 c1ed24a0 c1db1e84 c1db1e00 c02aa190 c02a9d44
1e00: c1ed24a0 c1e02000 c1db8160 c1e02360 00000000 00000000 c1db1e38 c1db9310
1e20: c1db94d0 c1db94d0 00000000 00000000 0b160040 00000000 c1e025dc c1db94d0
1e40: 00000000 00000000 00000000 00000152 00000001 00000000 00000002 c1db0000
1e60: c1ed24a0 c1e02800 c1ed24a0 c1e02800 c1db9554 c038f298 c1db1eac c1db1e88
1e80: c021629c c02a9eac c1db0000 c1e02800 c1e02800 c1ed24a0 ffffd682 c035ea94
1ea0: c1db1ed4 c1db1eb0 c0225584 c02160d8 c1db0000 c1e02800 c1ed24a0 00000000
1ec0: c1db9560 00000090 c1db1ef4 c1db1ed8 c02164d4 c02254b0 c1ed24a0 00000000
1ee0: c1e02360 c1ed24c0 c1db1f14 c1db1ef8 c029c590 c0216344 0000000c c1ed0045
1f00: c1ed24a0 c1ed0036 c1db1f4c c1db1f18 c029caa4 c029c538 c1ed0040 c1db8e8c
1f20: c1e02000 c1db8160 c1db0000 c1cf3a00 c1e02000 c02a2340 00000000 00000019
1f40: c1db1f74 c1db1f50 c02a24b0 c029c868 c1db8e5c c1db0000 c1cf3a00 c1db8e58
1f60: c02a2340 00000000 c1db1f98 c1db1f78 c0048d38 c02a2350 c1cf3a08 c1db1fb0
1f80: c1cf3a00 00000000 00000000 c1db1fdc c1db1f9c c0048ec0 c0048c60 00000000
1fa0: c1ecd0e0 c004cf20 c1db1fbc c1db1fbc 00000000 c1ecd0e0 c004cf20 c1db1fbc
1fc0: c1db1fbc fffffffc c0048e08 00000000 c1db1ff4 c1db1fe0 c004c848 c0048e18
1fe0: 00000000 00000000 00000000 c1db1ff8 c003a398 c004c804 00000000 00000000
Backtrace:
[<c0025588>] (__bug+0x0/0x2c) from [<c020ee74>] (skb_under_panic+0x5c/0x68)
[<c020ee18>] (skb_under_panic+0x0/0x68) from [<c020fd04>] (skb_push+0x3c/0x44)
 r7:00000001 r6:023a0000 r5:c1ed24a0 r4:00000020
[<c020fcc8>] (skb_push+0x0/0x44) from [<c01ae2c4>] (rtl8187_tx+0x20c/0x344)
 r5:00000001 r4:c1db1e00
[<c01ae0b8>] (rtl8187_tx+0x0/0x344) from [<c02a9d94>]
(__ieee80211_tx+0x60/0x168)
[<c02a9d34>] (__ieee80211_tx+0x0/0x168) from [<c02aa190>]
(ieee80211_master_start_xmit+0x2f4/0x468)
 r7:c1ed24a0 r6:00000000 r5:c1db0000 r4:c0374894
[<c02a9e9c>] (ieee80211_master_start_xmit+0x0/0x468) from [<c021629c>]
(dev_hard_start_xmit+0x1d4/0x26c)
[<c02160c8>] (dev_hard_start_xmit+0x0/0x26c) from [<c0225584>]
(__qdisc_run+0xe4/0x248)
[<c02254a0>] (__qdisc_run+0x0/0x248) from [<c02164d4>]
(dev_queue_xmit+0x1a0/0x308)
[<c0216334>] (dev_queue_xmit+0x0/0x308) from [<c029c590>]
(ieee80211_sta_tx+0x68/0x6c)
 r7:c1ed24c0 r6:c1e02360 r5:00000000 r4:c1ed24a0
[<c029c528>] (ieee80211_sta_tx+0x0/0x6c) from [<c029caa4>]
(ieee80211_send_probe_req+0x24c/0x260)
 r7:c1ed0036 r6:c1ed24a0 r5:c1ed0045 r4:0000000c
[<c029c858>] (ieee80211_send_probe_req+0x0/0x260) from [<c02a24b0>]
(ieee80211_sta_scan_work+0x170/0x1a4)
[<c02a2340>] (ieee80211_sta_scan_work+0x0/0x1a4) from [<c0048d38>]
(run_workqueue+0xe8/0x1b8)
[<c0048c50>] (run_workqueue+0x0/0x1b8) from [<c0048ec0>]
(worker_thread+0xb8/0xcc)
 r8:00000000 r7:00000000 r6:c1cf3a00 r5:c1db1fb0 r4:c1cf3a08
[<c0048e08>] (worker_thread+0x0/0xcc) from [<c004c848>] (kthread+0x54/0x7c)
 r6:00000000 r5:c0048e08 r4:fffffffc
[<c004c7f4>] (kthread+0x0/0x7c) from [<c003a398>] (do_exit+0x0/0x65c)
 r5:00000000 r4:00000000
Code: e1a01000 e59f000c eb004d54 e3a03000 (e5833000)
Kernel panic - not syncing: Fatal exception in interrupt


On Tue, May 20, 2008 at 6:24 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Sat, 2008-05-17 at 23:15 -0700, Paul Thomas wrote:
>
>> I was finally able to test the driver with an ARM9 (AT91RM9200)
>> processor, but I wasn't able to make it work. Here is the error I get:
>>
>> kernel BUG at net/core/skbuff.c:149!
>
> There should be a message starting with "skb_under_panic:" immediately
> before this.  It prints information about the skb.
>
>> Backtrace:
>> [<c0025588>] (__bug+0x0/0x2c) from [<c020ee54>] (skb_under_panic+0x5c/0x68)
>> [<c020edf8>] (skb_under_panic+0x0/0x68) from [<c020fce4>] (skb_push+0x3c/0x44)
>>  r7:c1d4be40 r6:023a0000 r5:c1d4be40 r4:00000020
>> [<c020fca8>] (skb_push+0x0/0x44) from [<c01ae2b8>] (rtl8187_tx+0x200/0x324)
>>  r5:00000001 r4:00000001
>
> So, we got there from skb_push().
>
>> [<c01ae0b8>] (rtl8187_tx+0x0/0x324) from [<c02a9d74>]
>> (__ieee80211_tx+0x60/0x168)
>
> rtl8187_tx() doesn't call skb_push() directly, but I think that
> rtl8187b_tx_buf() got inlined.
>
> Perhaps there is too little headroom space in the skb.  I would check if
> dev->extra_tx_headroom is correct in rtl8187_probe().
>
> Try checking the available headroom in rtl8187b_tx_buf() by
> skb_headroom().  If it's not enough, use skb_realloc_headroom() and
> print how much is missing.
>
> I know there were conflicts between the patch and the latest changes on
> linux-wireless.  Maybe you didn't resolve them correctly.
>
> Here's the patch for debugging the panic.
>
> And by the way, please provide the kernel log part from the device
> initialization time all the way to the panic.
>
> diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
> index 88e4d4b..8005651 100644
> --- a/drivers/net/wireless/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl8187_dev.c
> @@ -185,6 +185,13 @@ static void *rtl8187b_tx_buf(struct sk_buff *skb, __le32 flags,
>                             __le16 tx_dur)
>  {
>        struct rtl8187b_tx_hdr *hdr;
> +       int need_headroom;
> +
> +       need_headroom = sizeof(*hdr) - skb_headroom(skb);
> +       printk("rtl8187: need headroom: %zd, have %d\n", sizeof(*hdr),
> +              skb_headroom(skb));
> +       if (need_headroom)
> +               skb = skb_realloc_headroom(skb, need_headroom);
>
>        hdr = (struct rtl8187b_tx_hdr *)skb_push(skb, sizeof(*hdr));
>        memset(hdr, 0, sizeof(*hdr));
> @@ -1057,6 +1064,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
>        dev->extra_tx_headroom = (!priv->is_rtl8187b) ?
>                                  sizeof(struct rtl8187_tx_hdr) :
>                                  sizeof(struct rtl8187b_tx_hdr);
> +       printk("rtl8187: need headroom: %d, priv->is_rtl8187b = %d\n",
> +              dev->extra_tx_headroom, priv->is_rtl8187b);
>        if (!priv->is_rtl8187b)
>                dev->queues = 1;
>        else
>
>
> --
> Regards,
> Pavel Roskin
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44328 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaJGPMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 11:12:50 -0400
Received: by mail-wi0-f178.google.com with SMTP id cc10so8259026wib.5
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2014 08:12:49 -0700 (PDT)
Message-ID: <543402EF.8080509@gmail.com> (sfid-20141007_171253_628739_AC64056D)
Date: Tue, 07 Oct 2014 17:12:47 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: GSS_MTK_WCN_ACS@mediatek.com,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] MediaTek Inc. MT7601U Wireless Adapter
References: <53FCC55B.90705@gmail.com> <20140826182849.GE30445@tuxdriver.com> <53FD7BFA.1040304@maya.org> <20140827135550.GD15173@tuxdriver.com> <53FE9920.2040702@gmail.com> <5402B519.1080002@gmail.com> <54034EF1.6040407@maya.org> <5433542F.70206@gmail.com> <20141007135731.GF25590@tuxdriver.com> <5433FFC0.2040704@gmail.com>
In-Reply-To: <5433FFC0.2040704@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.10.2014 16:59, poma wrote:
> On 07.10.2014 15:57, John W. Linville wrote:
>> You probably shold be sending this to MediaTek.  The driver you are
>> using is not part of the upstream Linux kernel.
>>
>> John
>>
> 
> No problemos!
> 
> 

BTW, pán Gruszka, when will these devices be supported as a part of the upstream Linux kernel?


poma


>> On Tue, Oct 07, 2014 at 04:47:11AM +0200, poma wrote:
>>>
>>> BUG: unable to handle kernel paging request at ffffc9000277c070
>>> IP: [<ffffffff8165272c>] __netdev_watchdog_up+0xc/0x80
>>> PGD 12b01c067 PUD 12b01d067 PMD 1295e8067 PTE 0
>>> Oops: 0000 [#1] SMP 
>>> CPU: 3 PID: 1497 Comm: wpa_supplicant Tainted: G           OE  3.17.0-1.fc21.x86_64 #1
>>> task: ffff88007ec44e80 ti: ffff8800beddc000 task.ti: ffff8800beddc000
>>> RIP: 0010:[<ffffffff8165272c>]  [<ffffffff8165272c>] __netdev_watchdog_up+0xc/0x80
>>> RSP: 0018:ffff8800beddfcd8  EFLAGS: 00010202
>>> RAX: ffffc9000277c000 RBX: ffff8800caa3c000 RCX: ffff8800ca22a948
>>> RDX: 0000000000000000 RSI: 0000000000000005 RDI: ffff8800caa3c000
>>> RBP: ffff8800beddfce8 R08: 0000000000000000 R09: 0000000000000208
>>> R10: 0000000000000400 R11: 0000000000000010 R12: 0000000000000000
>>> R13: ffffc9000277c000 R14: 0000000000000000 R15: 0000000000000001
>>> FS:  00007fce557aa800(0000) GS:ffff88012fcc0000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> CR2: ffffc9000277c070 CR3: 000000007eeed000 CR4: 00000000000007e0
>>> Stack:
>>>  ffffffff816527e8 ffff8800caa3c000 ffff8800beddfd20 ffffffffa05e4655
>>>  ffffffffa05e4ab0 ffffffffa05e4510 000000005abd5236 ffff8800caa3c000
>>>  0000000000001003 ffff8800beddfd58 ffffffff8163135e ffff8800caa3c000
>>> Call Trace:
>>>  [<ffffffff816527e8>] ? netif_carrier_on+0x48/0x50
>>>  [<ffffffffa05e4655>] MainVirtualIF_open+0x85/0xe0 [mt7601Usta]
>>>  [<ffffffffa05e4ab0>] ? RtmpOSIRQRequest+0x60/0x60 [mt7601Usta]
>>>  [<ffffffffa05e4510>] ? RT28xx_get_ether_stats+0x150/0x150 [mt7601Usta]
>>>  [<ffffffff8163135e>] __dev_open+0xce/0x150
>>>  [<ffffffff8163168d>] __dev_change_flags+0x9d/0x160
>>>  [<ffffffff81631779>] dev_change_flags+0x29/0x70
>>>  [<ffffffff816a5bac>] devinet_ioctl+0x63c/0x710
>>>  [<ffffffff816a6d05>] inet_ioctl+0x65/0x90
>>>  [<ffffffff816105d5>] sock_do_ioctl+0x25/0x50
>>>  [<ffffffff81610b30>] sock_ioctl+0x1f0/0x2c0
>>>  [<ffffffff81220340>] do_vfs_ioctl+0x2d0/0x4b0
>>>  [<ffffffff812205a1>] SyS_ioctl+0x81/0xa0
>>>  [<ffffffff81135a16>] ? __audit_syscall_exit+0x1f6/0x2a0
>>>  [<ffffffff81743469>] system_call_fastpath+0x16/0x1b
>>> Code: 9b 48 a4 ff c6 05 bd 12 6b 00 01 48 8b 45 d8 e9 09 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 e8 01 00 00 <48> 83 78 70 00 74 41 55 48 89 e5 53 48 63 87 c0 03 00 00 85 c0 
>>> RIP  [<ffffffff8165272c>] __netdev_watchdog_up+0xc/0x80
>>>  RSP <ffff8800beddfcd8>
>>> CR2: ffffc9000277c070
>>> ---[ end trace 97a7adc75a3f40f8 ]---
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> 


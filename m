Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:36819
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZAFU6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 15:58:19 -0500
Message-ID: <4963C43D.1080209@erley.org> (sfid-20090106_215823_241613_7AEFEFB0)
Date: Tue, 06 Jan 2009 15:51:09 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: "W. van den Akker" <listsrv@wilsoft.nl>
CC: linux-wireless@vger.kernel.org
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
References: <200901011444.20333.listsrv@wilsoft.nl> <200901060857.41357.listsrv@wilsoft.nl> <200901061552.45729.listsrv@wilsoft.nl> <200901062132.04403.listsrv@wilsoft.nl>
In-Reply-To: <200901062132.04403.listsrv@wilsoft.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W. van den Akker wrote:
--- Snip ---
>>
>> However, after starting a internet session and Kmail session the server
>> hangs again without any output. Does the NMI-handler not process per CPU?
>> So if one CPU hangs, the other would still proceed?
>>
>> I have no 802.11n enabled, nor X.
>>
>> This means I think the system halted hard 'hlt-instruction'
>>
>> Any further suggestion? I am little bit hopeless now. I have placed the PCI
>> card into another slot, no result.
> 
> Some additional information:
> I have booted the server at approx 16:00. Hostapd was started at boot-time.
> After 5 hours without any connection from any computers the server hangs.
> 

Just as a data point, I'm running master mode with ath9k on 64bit with
multiple clients and have no problems.  Perhaps it's hardware version
related?  Here's the info for my system:

kernel: 2.6.28-gentoo
compat-wireless-2.6: cedd75beb269e2b559a5174ee628ebd01f63a4040
wireless-testing: fd1dae5fbc7a260b0ddfab7d4939a766a82ef3f3
hostapd: 2c04820d80b5c489576cb735c3be8f026a035a5b

I have 80211n enabled for my device with this config:

ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]

my device:

Network controller: Atheros Communications, Inc. AR5416 802.11a/b/g/n
Wireless PCI Adapter (rev 01)

phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81:
mem=0xffffc20000060000, irq=17

Currently I'm using my ps3, axim, laptop, and a netbook at the same
time, and have no disconnects.  Any additional testing I could do that
might help you out, or more information I could provide you?

Pat Erley

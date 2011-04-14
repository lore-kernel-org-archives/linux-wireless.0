Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout08.t-online.de ([194.25.134.20]:53123 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab1DNMzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 08:55:47 -0400
Message-ID: <4DA6EEF8.9090701@t-online.de>
Date: Thu, 14 Apr 2011 14:56:24 +0200
From: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	622753@bugs.debian.org, Gunnar Stahl <gunnar.stahl@gunnarstahl.org>
Subject: Re: ath9k: Connection over wlan slows down and dies
References: <20110414123925.31837.14741.reportbug@noomadix> <1302785635.5282.690.camel@localhost>
In-Reply-To: <1302785635.5282.690.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 14.04.2011 14:53, schrieb Ben Hutchings:
> I received this bug report on ath9k:
>
> On Thu, 2011-04-14 at 14:39 +0200, Gunnar Stahl wrote:
>> Package: linux-2.6
>> Version: 2.6.38-3
>> Severity: important
>>
>> Since linux-image-2.6.38-2-amd64 the wlan connections on this machine is 1)
>> slow to connection and 2) slows down to a crawl and 3) dies after some seconds
>> / mintes and becomes completely unusable.
>>
>> Connecting over standard eth0 makes no problems at all. Only the wlan is
>> affected.
>>
>> Booting the same machine again with linux-image-2.6.32-5-amd64 turns the wlan
>> back to normal again.
> [...]
>> 02:00.0 Network controller [0280]: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) [168c:002b] (rev 01)
>> 	Subsystem: AzureWave Device [1a3b:1089]
>> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
>> 	Latency: 0, Cache Line Size: 32 bytes
>> 	Interrupt: pin A routed to IRQ 17
>> 	Region 0: Memory at feaf0000 (64-bit, non-prefetchable) [size=64K]
>> 	Capabilities:<access denied>
>> 	Kernel driver in use: ath9k
> [...]
>
> Further system details at<http://bugs.debian.org/622753>.
>
> Ben.
>

https://bugzilla.kernel.org/show_bug.cgi?id=31452

-- 
Regards,
Richard Schütz

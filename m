Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:48234 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbYG2OGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 10:06:06 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1514030ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 07:06:05 -0700 (PDT)
Message-ID: <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com> (sfid-20080729_160610_624604_63C2CFFA)
Date: Tue, 29 Jul 2008 17:06:04 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217339170.10489.62.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217334452.10489.42.camel@johannes.berg>
	 <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 <1217339170.10489.62.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 4:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 16:43 +0300, Tomas Winkler wrote:
>
>> No the mistake is on your side. FIFO is not relevant here. What is
>> important is whether HW queue is full or not.
>> Except the AC Back off scheduling done by FIFO there is BA protocol
>> which my stall HW queue. It doesn't mean that other packets with the
>> same FIFO should be stalled. You need additional SW queue that can be
>> stopped.
>
> HW queues are irrelevant, you're the only vendor that implements it with
> HW queues. If you think they're required for correct operation, clearly
> you're wrong.

Please put some reasoning behind this 'wrong'?  Different doesn't mean
wrong and 'only one' certainly doesn't mean wrong.
And it also doesn't mean that this hw should not operates correctly
under Linux. I also cannot publish any performance comparison but it
doesn't look wrong at all.

If Intel is the only vendor implements this that way that we may push
the extra queuing into driver
but so far I've seen only athk9 with 11n.

> I'm just trying to fix the bugs and find a way to do this with hardware
> that doesn't have extra HW queues.

I don't want to even answer to this.

Tomas

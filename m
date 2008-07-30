Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:37339 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYG3MBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 08:01:37 -0400
Received: by rv-out-0506.google.com with SMTP id k40so389956rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 05:01:36 -0700 (PDT)
Message-ID: <1ba2fa240807300501lbc54fcdu18f805b6c8f1c91f@mail.gmail.com> (sfid-20080730_140144_719222_5FF1861D)
Date: Wed, 30 Jul 2008 15:01:36 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>
In-Reply-To: <1217411631.10489.103.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 <1217411631.10489.103.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 30, 2008 at 12:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 18:55 +0300, Tomas Winkler wrote:
>
>> So why do you need 4 HW queues for QoS, every vendor now implements it
>> that way today. There is only one medium, you don't put 4 packets on
>> the air at the same time.
>
> The single medium part is true, but the scheduling decision is best made
> at the air interface, otherwise you'd need to be able to kill the hw
> fifo when a high-prio frame comes in to preempt other frames.

The scheduling decision is made there. high priority packet is
scheduled to different hw fifo.
This issue is really no concern here.

>> Now imaging that withing single queue you
>> have another priority level why it is wrong to add another queue for
>> it?
>
> What makes you think aggregation is another priority level though? I
> don't see any evidence that it is, and everybody I've asked so far seems
> to agree with me.

Not it's not priority level in proper sense I just want to make the
picture tangible to you. There is world 'imagine'  in the sentence.
I've focused on less important part of the explanation.
What is more important that it's different stream I hope that
Frederich made it clearer

Tomas

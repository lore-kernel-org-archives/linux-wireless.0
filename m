Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35318 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbcGSOcO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 10:32:14 -0400
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: Michal Kazior <michal.kazior@tieto.com>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <CA+BoTQ=Bi070XDXNjq6ypzs3w0+9OYM_8tXeikSR_a0TMN2P=g@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <847b99c3-1e68-6d05-e012-24decd8f44b6@nbd.name> (sfid-20160719_163217_991754_E20C93BB)
Date: Tue, 19 Jul 2016 16:32:08 +0200
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=Bi070XDXNjq6ypzs3w0+9OYM_8tXeikSR_a0TMN2P=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-07-19 15:13, Michal Kazior wrote:
> On 12 July 2016 at 12:09, Felix Fietkau <nbd@nbd.name> wrote:
>> Hi,
>>
>> With Toke's ath9k txq patch I've noticed a pretty nasty performance
>> regression when running local iperf on an AP (running the txq stuff) to
>> a wireless client.
>>
>> Here's some things that I found:
>> - when I use only one TCP stream I get around 90-110 Mbit/s
>> - when running multiple TCP streams, I get only 35-40 Mbit/s total
> 
> What is the baseline here (i.e. without fq/txq stuff)? Is it ~100mbps?
Yes.

> Did you try running multiple streams, each on separate tids (matching
> the same AC perhaps) or different clients?
Not yet.

- Felix

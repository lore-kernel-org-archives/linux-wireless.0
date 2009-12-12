Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:33357 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZLLLkl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 06:40:41 -0500
Received: by ey-out-2122.google.com with SMTP id d26so504144eyd.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Dec 2009 03:40:47 -0800 (PST)
From: Vitalik Nikolyenko <vnik5287@gmail.com>
In-Reply-To: <1260617445.2442.332.camel@johannes.local>
Mime-Version: 1.0 (iPhone Mail 7A400)
References: <157c4da70912120218lc53633bk62fc9ee99377a231@mail.gmail.com>
	<1260613513.2442.319.camel@johannes.local> <157c4da70912120329n4b6bc663ic47e95201f7569da@mail.gmail.com>
	<1260617445.2442.332.camel@johannes.local>
Date: Sat, 12 Dec 2009 22:40:38 +1100
Message-ID: <-3945137922086923095@unknownmsgid>
Subject: Re: mac80211 noob question
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for not being very clear. I'm capturing on C and just want to
check if B acked A's frame (if that's possible)

On Dec 12, 2009, at 10:30 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:

> On Sat, 2009-12-12 at 22:29 +1100, VN wrote:
>> Ah I guess I am. I just assumed that since I'm able to capture data
>> frames sent from node A to node B (w/o radiotap?), there should be
>> some way to check which ones were acknowledged by node B. Thanks for
>> your prompt response!
>
> But are you capturing on A or on B? If you're capturing on A, then
> yes,
> you can figure out whether it was ACKed by B and A received the ACK --
> pull up a monitor interface and see the info you get from it.
>
> johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:7073 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579AbXGYSFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 14:05:20 -0400
Received: by wa-out-1112.google.com with SMTP id v27so294769wah
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 11:05:19 -0700 (PDT)
Message-ID: <b3153e950707251105w4aebcd81w3e3bfc077385ea01@mail.gmail.com>
Date: Wed, 25 Jul 2007 11:05:18 -0700
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
Cc: "John W. Linville" <linville@tuxdriver.com>,
	mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1184754598.4658.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <46137FF2.6020203@linux.intel.com>
	 <1182374019.3714.87.camel@johannes.berg>
	 <20070718000140.GA26907@tuxdriver.com>
	 <1184754598.4658.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I thought the Destinations Address (DA) and Senders Address (SA)
parameter values in the subframe header must map to the
same Receiver Address (RA) and Transmitter Address (TA)
in the MAC header. Thus, broadcasting or multicasting is not allowed.


On 7/18/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2007-07-17 at 20:01 -0400, John W. Linville wrote:
>
> > > Here you allocate a new frame which can be sent back to the device when
> > > one of the aggregated frames was a multicast frame and we're an AP
> > > device. You also correctly add extra_tx_headroom, but it seems that this
> > > is missing some skb_reserve(extra_tx_headroom), no? Could you make a
> > > patch adding it? I'm not sure I fully understand the code there.
> >
> > Was there ever any reply to this?
>
> I didn't get one but never double-checked the code either, the relevant
> patches I had touching this have fallen off the list anyway :)
>
> johannes
>
>

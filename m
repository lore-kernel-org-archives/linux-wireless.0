Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:27996 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbXGRPvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 11:51:42 -0400
Received: by wx-out-0506.google.com with SMTP id h31so228252wxd
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2007 08:51:41 -0700 (PDT)
Message-ID: <1ba2fa240707180851y22ead404g1c87d73903e939e3@mail.gmail.com>
Date: Wed, 18 Jul 2007 18:51:41 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
Cc: "John W. Linville" <linville@tuxdriver.com>,
	mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240707180622p791168eax4fae712641e24cc4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <46137FF2.6020203@linux.intel.com>
	 <1182374019.3714.87.camel@johannes.berg>
	 <20070718000140.GA26907@tuxdriver.com>
	 <1184754598.4658.14.camel@johannes.berg>
	 <1ba2fa240707180622p791168eax4fae712641e24cc4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/18/07, Tomas Winkler <tomasw@gmail.com> wrote:
> On 7/18/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2007-07-17 at 20:01 -0400, John W. Linville wrote:
> >
> > > > Here you allocate a new frame which can be sent back to the device when
> > > > one of the aggregated frames was a multicast frame and we're an AP
> > > > device.
> HT aggregtion is extension of QoS. Multicast and broadcast frames are
> not QoS frames and therefore such frames  want be incorporated into an
> A-MSDU.
Oops
s/want/won't/

> You also correctly add extra_tx_headroom, but it seems that this
> > > > is missing some skb_reserve(extra_tx_headroom), no? Could you make a
> > > > patch adding it? I'm not sure I fully understand the code there.
> > >
> > > Was there ever any reply to this?
> >
> > I didn't get one but never double-checked the code either, the relevant
> > patches I had touching this have fallen off the list anyway :)
> >
> > johannes
> >
> >
>

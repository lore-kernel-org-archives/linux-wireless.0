Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:42787 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761013AbXGYTOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 15:14:04 -0400
Received: by wx-out-0506.google.com with SMTP id h31so270406wxd
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 12:14:03 -0700 (PDT)
Message-ID: <1ba2fa240707251214k1711cd5ex4107cc5ab1db60a9@mail.gmail.com>
Date: Wed, 25 Jul 2007 22:14:03 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "mohamed salim abbas" <mabbaswireless@gmail.com>
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <b3153e950707251105w4aebcd81w3e3bfc077385ea01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <46137FF2.6020203@linux.intel.com>
	 <1182374019.3714.87.camel@johannes.berg>
	 <20070718000140.GA26907@tuxdriver.com>
	 <1184754598.4658.14.camel@johannes.berg>
	 <b3153e950707251105w4aebcd81w3e3bfc077385ea01@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/25/07, mohamed salim abbas <mabbaswireless@gmail.com> wrote:
> I thought the Destinations Address (DA) and Senders Address (SA)
> parameter values in the subframe header must map to the
> same Receiver Address (RA) and Transmitter Address (TA)
> in the MAC header. Thus, broadcasting or multicasting is not allowed.
>
The packet as whole can be a multicast packet
>
> On 7/18/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2007-07-17 at 20:01 -0400, John W. Linville wrote:
> >
> > > > Here you allocate a new frame which can be sent back to the device when
> > > > one of the aggregated frames was a multicast frame and we're an AP
> > > > device. You also correctly add extra_tx_headroom, but it seems that this
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
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

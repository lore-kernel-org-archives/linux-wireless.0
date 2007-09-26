Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:18438 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbXIZMcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 08:32:53 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2768526wah
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2007 05:32:52 -0700 (PDT)
Message-ID: <1ba2fa240709260532i17d25d78u63e0829f3002f6c1@mail.gmail.com>
Date: Wed, 26 Sep 2007 14:32:48 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: A-MSDU deaggregation support
Cc: "mohamed salim abbas" <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Michael Wu" <flamingice@sourmilk.net>, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1190809015.4204.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1189354526.4506.25.camel@johannes.berg>
	 <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
	 <1190747966.18521.320.camel@johannes.berg>
	 <1ba2fa240709251624ycb516c4t90bcb6846800b18@mail.gmail.com>
	 <1190792394.18521.354.camel@johannes.berg>
	 <1ba2fa240709260446u2facb62fw1a17af1665b25d03@mail.gmail.com>
	 <1190809015.4204.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/26/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-09-26 at 13:46 +0200, Tomas Winkler wrote:
>
> > > The only problem I see with not doing this is that hostapd will have to
> > > listen for EAPOL frames on all VLAN interfaces but I suppose that is
> > > doable.
> > >
> > I wonder of port control is done for ethernet. 1X is not WLAN invention.
> > I'll try to dig it.
>
> I haven't ever seen it, but I'm not sure.
I'm sure.
>
> > > > The problem is the order of the handlers.  First you need to
> > > > deaggregated the frame then filtered out non EAPLOL frames if the port
> > > > is not open.
> > >
> > > Yeah, I know, I had a plan a while back, will see if I can implement it.
> > >
> > Hope to get there as well in near future.
>
> Ok, let me know what you plan to do. John has pushed the deagg patch
> into the "dungeon" branch so it's still there for reference.

Oh... another victim.  Getting lost in current patch movement... Looks
like most of the decision are happening somewhere else...

> johannes
>
>

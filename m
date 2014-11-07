Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58133 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaKGTPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:15:25 -0500
Message-ID: <1415387721.1954.0.camel@sipsolutions.net> (sfid-20141107_201528_062904_F58B9636)
Subject: Re: [PATCH] mac80211: add back support for radiotap vendor
 namespace data
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Nov 2014 20:15:21 +0100
In-Reply-To: <1415363870.12617.0.camel@coelho.fi>
References: <1415312956-9442-1-git-send-email-johannes@sipsolutions.net>
	 <1415363870.12617.0.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-07 at 14:37 +0200, Luca Coelho wrote:

> > +#if 0
> > +	struct ieee80211_vendor_radiotap *rtap;
> > +
> > +	rtap = (void *)skb_push(skb, sizeof(*rtap) + 8 + 4);
> > +	/*
> > +	 * Don't enable this code by default as the OUI 00:00:00
> > +	 * is registered to Xerox so we shouldn't use it here, it
> > +	 * might find its way into pcap files.
> > +	 * Note that this code requires the headroom in the SKB
> > +	 * that was allocated earlier.
> > +	 */

> Is this #if 0'ed section here on purpose? If yes, maybe explain it in
> the commit message?

You're the second person to ask this, but come on ... really? :)

johannes


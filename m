Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54493 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbcHKSDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 14:03:51 -0400
Message-ID: <1470938627.12075.25.camel@sipsolutions.net> (sfid-20160811_200354_722106_FC417916)
Subject: Re: [RESEND PATCH] nl80211: Allow GET_INTERFACE dumps to be filtered
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Thu, 11 Aug 2016 20:03:47 +0200
In-Reply-To: <57ACA9E9.4020507@gmail.com> (sfid-20160811_183804_837759_60BA2092)
References: <1470261735-2977-1-git-send-email-denkenz@gmail.com>
	 <1470919643.12075.7.camel@sipsolutions.net> <57ACA9E9.4020507@gmail.com>
	 (sfid-20160811_183804_837759_60BA2092)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-08-11 at 11:38 -0500, Denis Kenzior wrote:
> Hi Johannes,
> 
> On 08/11/2016 07:47 AM, Johannes Berg wrote:
> > 
> > On Wed, 2016-08-03 at 17:02 -0500, Denis Kenzior wrote:
> > > 
> > > 
> > > +static int nl80211_dump_interface_parse(struct sk_buff *skb,
> > > +				    struct netlink_callback *cb,
> > > +				    int *filter_wiphy)
> > 
> > Wrong indentation :)
> 
> Sorry :)
> 
> Speaking of indentation, can you point me to a doc of the rules I
> should follow?

You've seen Documentation/CodingStyle?

> I can confirm that I sanity checked this patch. Both ATTR_WIPHY, 
> ATTR_WDEV and wildcard dumps seemed to produce expected results.

I think it probably works due to the other conditions?

> I noticed you applied this patch.  Is there a particular scenario
> where it goes wrong or did you convince yourself it is correct?
> 

No, that was a mistake :( I've removed it now.

johannes

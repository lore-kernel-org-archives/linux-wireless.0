Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37774 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752200AbeCUPJ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 11:09:29 -0400
Message-ID: <1521644967.2645.31.camel@sipsolutions.net> (sfid-20180321_160932_497562_3AC8CB4D)
Subject: Re: [RFC v5 3/9] nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 21 Mar 2018 16:09:27 +0100
In-Reply-To: <286ad6b3-479c-0294-b123-7f68b5e6349a@gmail.com> (sfid-20180321_160157_210862_1F091AE6)
References: <20180313215942.29176-1-denkenz@gmail.com>
         <20180313215942.29176-4-denkenz@gmail.com>
         <1521618479.2645.1.camel@sipsolutions.net>
         <286ad6b3-479c-0294-b123-7f68b5e6349a@gmail.com>
         (sfid-20180321_160157_210862_1F091AE6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-21 at 10:01 -0500, Denis Kenzior wrote:
> Hi Johannes,
> 
> On 03/21/2018 02:47 AM, Johannes Berg wrote:
> > On Tue, 2018-03-13 at 16:59 -0500, Denis Kenzior wrote:
> > > 
> > > +	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
> > > +		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER])
> > > +			return -EINVAL;
> > > 
> > 
> > There might be value in adding GENL_SET_ERR_MSG() calls to new
> > instances of -EINVAL, but if you don't want to do that now I won't
> > insist (and perhaps add some when I apply the patches).
> > 
> 
> Sure, that sounds easy enough.  Did you see the TODO comments I added in 
> RFC v5 0/9 message?  I need your help figuring out how you want to 
> handle those.  Those are pretty esoteric though and would require more 
> surgery.

Sorry, I hadn't. I'll take a look now.

> Any chance that we can merge the non-controversial bits of this RFC so 
> that we can get some wider testing and start encouraging non-mac80211 
> based drivers to support these mechanisms?

Yeah, sure, we can do that.

johannes

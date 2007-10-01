Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.232]:44603 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXJAXer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2007 19:34:47 -0400
Received: by nz-out-0506.google.com with SMTP id s18so2739731nze
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2007 16:34:46 -0700 (PDT)
Message-ID: <1ba2fa240710011634g2361b2fcn7466202f925fc8c4@mail.gmail.com> (sfid-20071002_003455_164035_F48947BC)
Date: Tue, 2 Oct 2007 01:34:45 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211 multiqueue
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <20071001201236.GB5224@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1189076408.28781.49.camel@johannes.berg>
	 <1189146702.16788.103.camel@debian.sh.intel.com>
	 <1189172436.28781.148.camel@johannes.berg>
	 <1189390172.24707.36.camel@debian.sh.intel.com>
	 <20071001201236.GB5224@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/1/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Mon, Sep 10, 2007 at 10:09:32AM +0800, Zhu Yi wrote:
> > On Fri, 2007-09-07 at 15:40 +0200, Johannes Berg wrote:
>
> > > > BTW， the whole 802.11 qdisc hack will be removed with
> > > > the multiqueue supported in .24.
> > >
> > > Yeah, is anybody working on that? I have to admit I didn't look into
> > > that yet.
> >
> > If nobody will work on that, we Intel will do. I remembered Tomas
> > promised John in this OLS ;)
>
> Indeed he did...Tomas, any progress on this?
>

Not much, yet it's definitely on the list. This will get priority
after we have proper 11n in mac80211,  hope soon, as I'm getting more
familiar with Johannes revolution.

I'm still wondering how multiqueue will be used effectively with
stacking it between wlanX and wmasterX as native 80211 interface is
far to reach.

Tomas

> John
> --
> John W. Linville
> linville@tuxdriver.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

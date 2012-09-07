Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2IGPzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 11:55:13 -0400
Message-ID: <1347033342.4256.28.camel@jlt4.sipsolutions.net> (sfid-20120907_175518_395340_5F07C33F)
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Date: Fri, 07 Sep 2012 17:55:42 +0200
In-Reply-To: <201209071747.09666.chunkeey@googlemail.com> (sfid-20120907_174716_872095_038A8EE6)
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net>
	 <1346770467.3737.32.camel@jlt4.sipsolutions.net>
	 <1347020234.4256.22.camel@jlt4.sipsolutions.net>
	 <201209071747.09666.chunkeey@googlemail.com>
	 (sfid-20120907_174716_872095_038A8EE6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 17:47 +0200, Christian Lamparter wrote:
> On Friday 07 September 2012 14:17:14 Johannes Berg wrote:
> > On Tue, 2012-09-04 at 16:54 +0200, Johannes Berg wrote:
> >
> > If you want this for your driver, I'll commit this:
> > 
> > http://p.sipsolutions.net/ea2e3dbe980f5db8.txt
> 
> Won't this totally disable the crypto offload
> capabilities in AP mode?

Yes, though we could add an nl80211 attribute that allows hostapd to
tell us, and then if it did tell us we could know and do the right thing
here.

> I sort of prefer the nohwcrypt switch as it won't
> interfere with running user setups as much (so we
> don't burden systems like that weird telekom
> streamin-box (Vision S100 - it's name I think)
> that came with a p54pci minipci card and are
> now used for different purposes by some.

I guess it would make sense then to give hostapd the ability to tell us?

It's up to you. I don't need 11w, nor do I have p54 hardware, nor does
it matter much to me ... :)

johannes


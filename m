Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60803 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbaICLnq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 07:43:46 -0400
Message-ID: <1409744618.911.2.camel@jlt4.sipsolutions.net> (sfid-20140903_134349_850041_6C92963D)
Subject: Re: [PATCHv4 1/2] cfg80211: enable dynack through nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Date: Wed, 03 Sep 2014 13:43:38 +0200
In-Reply-To: <CAA2SeNKcF37iC0e+n8nrtabT8qwYE9tqD3RCGsSeiBmyxJjhjQ@mail.gmail.com> (sfid-20140829_224608_546052_1439D439)
References: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406556148-3924-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1407770081.9844.12.camel@jlt4.sipsolutions.net>
	 <CAA2SeNLg3mktDY0u4=ksHr4QvXewx4koeGkCAW8upqrS6gMg0g@mail.gmail.com>
	 <1409310171.4577.13.camel@jlt4.sipsolutions.net>
	 <CAA2SeNKcF37iC0e+n8nrtabT8qwYE9tqD3RCGsSeiBmyxJjhjQ@mail.gmail.com>
	 (sfid-20140829_224608_546052_1439D439)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-08-29 at 22:46 +0200, Lorenzo Bianconi wrote:
> > Hi,
> >
> > Sorry for the delay.
> >
> >> dynack is disable by default at bootstrap and it is automatically
> >> disabled as soon as you set coverage_class (coverage_class >= 0) after
> >> dynack has been enabled (coverage_class = -1). E.g:
> >>
> >> - iw phy phy0 set distance auto (to enable dynack)
> >>
> >> - iw phy phy0 set distance x (to set coverage class and disable dynack)
> >>
> >>
> >> This logic is implemented in dynack code. Is it fine for you?
> >
> > Ok, I guess that's reasonable. The default coverage class is 0 I guess?
> 
> Yes, dynack is disabled at bootstrap and default coverage class is 0
> 
> >
> >> Anyway documentation should be clearer on that stuff. :)
> >
> > Please extend it then? :)
> >
> 
> I will send a new patchset with more comments on that stuff :)

Please also include a better commit message actually explaining the
feature :)

johannes


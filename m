Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58582 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbaH2LCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 07:02:54 -0400
Message-ID: <1409310171.4577.13.camel@jlt4.sipsolutions.net> (sfid-20140829_130257_704793_9FD7511C)
Subject: Re: [PATCHv4 1/2] cfg80211: enable dynack through nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Date: Fri, 29 Aug 2014 13:02:51 +0200
In-Reply-To: <CAA2SeNLg3mktDY0u4=ksHr4QvXewx4koeGkCAW8upqrS6gMg0g@mail.gmail.com> (sfid-20140812_002559_030837_916613BB)
References: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406556148-3924-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1407770081.9844.12.camel@jlt4.sipsolutions.net>
	 <CAA2SeNLg3mktDY0u4=ksHr4QvXewx4koeGkCAW8upqrS6gMg0g@mail.gmail.com>
	 (sfid-20140812_002559_030837_916613BB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for the delay.

> dynack is disable by default at bootstrap and it is automatically
> disabled as soon as you set coverage_class (coverage_class >= 0) after
> dynack has been enabled (coverage_class = -1). E.g:
> 
> - iw phy phy0 set distance auto (to enable dynack)
> 
> - iw phy phy0 set distance x (to set coverage class and disable dynack)
> 
> 
> This logic is implemented in dynack code. Is it fine for you?

Ok, I guess that's reasonable. The default coverage class is 0 I guess?

> Anyway documentation should be clearer on that stuff. :)

Please extend it then? :)

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45003 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbaIELzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 07:55:43 -0400
Message-ID: <1409918136.14663.1.camel@jlt4.sipsolutions.net> (sfid-20140905_135546_827152_6122A077)
Subject: Re: [PATCHv5 0/2] configure dynack through mac80211/cfg80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Date: Fri, 05 Sep 2014 13:55:36 +0200
In-Reply-To: <1409916684.1940.8.camel@jlt4.sipsolutions.net> (sfid-20140905_133151_905927_75A03AAF)
References: <1409867861-3911-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20140904_235745_382608_527F8DE1) <1409916684.1940.8.camel@jlt4.sipsolutions.net>
	 (sfid-20140905_133151_905927_75A03AAF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-05 at 13:31 +0200, Johannes Berg wrote:
> On Thu, 2014-09-04 at 23:57 +0200, Lorenzo Bianconi wrote:
> > Enable ACK timeout estimation algorithm (dynack) using mac80211
> > set_coverage_class API. Dynack is activated passing -1 as coverage class
> > to lower drivers and it is automatically disabled setting valid value for
> > coverage class. Currently dynack is supported just by ath9k.
> > Fix set_coverage_class signature for p54, ath9k, ath9k_htc and ath5k drivers.
> 
> Applied.

Forgot to say - I renumbered the nl80211 feature bit and attribute as it
was conflicting with Emmanuel's patches (and it was easier to resolve
this way around)

johannes


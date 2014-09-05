Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44785 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950AbaIELbc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 07:31:32 -0400
Message-ID: <1409916684.1940.8.camel@jlt4.sipsolutions.net> (sfid-20140905_133151_905927_75A03AAF)
Subject: Re: [PATCHv5 0/2] configure dynack through mac80211/cfg80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Date: Fri, 05 Sep 2014 13:31:24 +0200
In-Reply-To: <1409867861-3911-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140904_235745_382608_527F8DE1)
References: <1409867861-3911-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20140904_235745_382608_527F8DE1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-04 at 23:57 +0200, Lorenzo Bianconi wrote:
> Enable ACK timeout estimation algorithm (dynack) using mac80211
> set_coverage_class API. Dynack is activated passing -1 as coverage class
> to lower drivers and it is automatically disabled setting valid value for
> coverage class. Currently dynack is supported just by ath9k.
> Fix set_coverage_class signature for p54, ath9k, ath9k_htc and ath5k drivers.

Applied.

johannes


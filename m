Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48352 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967265Ab3DRMUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 08:20:38 -0400
Received: by mail-wi0-f174.google.com with SMTP id m6so3964550wiv.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 05:20:36 -0700 (PDT)
Date: Thu, 18 Apr 2013 14:16:28 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/2] mac80211: minstrel_ht: pick only supported rates for
 sta and group max*rates
Message-ID: <20130418121628.GB8638@magnum.frso.rivierawaves.com> (sfid-20130418_142040_766735_F74319D5)
References: <1366285887-23416-1-git-send-email-karl.beldan@gmail.com>
 <1366287462.8336.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366287462.8336.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 18, 2013 at 02:17:42PM +0200, Johannes Berg wrote:
> On Thu, 2013-04-18 at 13:51 +0200, Karl Beldan wrote:
> 
> > +			// initialize {mg,mi}->max_rates indexes
> 
> Please don't use C99 comments (both here and the other patch)
> 
Oops, will fix this.
 
Karl

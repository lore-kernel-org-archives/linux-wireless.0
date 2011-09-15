Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1IOJUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:20:55 -0400
Subject: Re: [PATCH 1/2] wl12xx: remove TIM ie from probe response
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1316077625-20014-1-git-send-email-eliad@wizery.com> (sfid-20110915_110715_278978_BBE025D2)
References: <1316077625-20014-1-git-send-email-eliad@wizery.com>
	 (sfid-20110915_110715_278978_BBE025D2)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 11:20:52 +0200
Message-ID: <1316078452.3992.6.camel@jlt3.sipsolutions.net> (sfid-20110915_112057_352867_5E3D58AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 12:07 +0300, Eliad Peller wrote:
> wl12xx uses the beacon as the probe response template.
> However, the beacon includes a TIM ie, which shouldn't
> exist in the probe response.
> 
> Delete it from the skb before configuring the probe
> response template.

Are you sure all this is a good thing instead of getting the right info
from hostapd/wpa_s like for ath6kl? (Yeah, I know that's still
different, but ...)

johannes


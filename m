Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44791 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001AbaIELc0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 07:32:26 -0400
Message-ID: <1409916744.1940.9.camel@jlt4.sipsolutions.net> (sfid-20140905_133229_464484_91C4E46E)
Subject: Re: [PATCH] mac80211: fix broken use of VHT/20Mhz with some APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>
Date: Fri, 05 Sep 2014 13:32:24 +0200
In-Reply-To: <1409859475-10364-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409859475-10364-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-04 at 22:37 +0300, Emmanuel Grumbach wrote:
> From: Eyal Shapira <eyal@wizery.com>
> 
> commit "mac80211: disable 40MHz support in case of 20MHz AP"
> broke working VHT in 20Mhz with APs like Netgear R6300v2 which
> do not publish support for 40Mhz but allow use of VHT in 20Mhz.
> The break is because VHT is disabled once no HT cap doesn't indicate
> support for 40Mhz. This causes the assoc request to be sent without
> any VHT IE and the association is only HT due to this.
> 
> For more details check out commit 4a817aa7
> "mac80211: allow VHT with peers not capable of 40MHz"

Applied.

johannes


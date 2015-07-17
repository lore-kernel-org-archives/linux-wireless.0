Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52704 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbbGQMfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 08:35:32 -0400
Message-ID: <1437136527.1933.9.camel@sipsolutions.net> (sfid-20150717_143536_573716_E1854DE0)
Subject: Re: [PATCH v3] cfg80211: Handle minimum bandwidth for quarter and
 half rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2015 14:35:27 +0200
In-Reply-To: <1434035553-6621-1-git-send-email-matthias.may@neratec.com> (sfid-20150611_171301_187773_8C09D939)
References: <1434035553-6621-1-git-send-email-matthias.may@neratec.com>
	 (sfid-20150611_171301_187773_8C09D939)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-11 at 17:12 +0200, Matthias May wrote:
> The goal of this patch is to improve regd handling of quarter and 
> half rates.
> 
> The original assumption of 20MHz wide channels is with the 
> introduction of
> quarter and half rates no longer true.
> With this patch we no longer disable all channels that don't fit into 
> the
> 20MHz grid, but instead set the appropriate flags to disable 
> operation on
> specific bandwidths.
> 
Applied.

johannes

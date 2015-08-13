Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47841 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbbHMLzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 07:55:37 -0400
Message-ID: <1439466935.2114.22.camel@sipsolutions.net> (sfid-20150813_135539_965787_3118EBBF)
Subject: Re: [PATCH v4] cfg80211: Handle minimum bandwidth for quarter and
 half rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 13 Aug 2015 13:55:35 +0200
In-Reply-To: <1437139719-1580-1-git-send-email-matthias.may@neratec.com> (sfid-20150717_152852_669092_2AFC227D)
References: <1437139719-1580-1-git-send-email-matthias.may@neratec.com>
	 (sfid-20150717_152852_669092_2AFC227D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-07-17 at 15:28 +0200, Matthias May wrote:
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

Applied.

johannes


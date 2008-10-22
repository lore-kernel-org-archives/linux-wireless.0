Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58657 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759143AbYJVT3U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:29:20 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 12:29:20 -0700
Date: Wed, 22 Oct 2008 05:29:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wireless: remove struct regdom hinting
Message-ID: <20081022122914.GH6190@tesla> (sfid-20081022_212940_612267_9DFAD4EF)
References: <1224585042.5521.7.camel@johannes.berg> <20081022113950.GE6190@tesla> <1224701496.30459.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224701496.30459.50.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 11:51:36AM -0700, Johannes Berg wrote:
> -/* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
> +/* wiphy is set if this request's initiator is REGDOM_SET_BY_COUNTRY_IE */

Why don't we want to keep track of the wiphy if the driver set it?

  Luis

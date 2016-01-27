Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48619 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555AbcA0Odv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 09:33:51 -0500
Message-ID: <1453905229.2351.8.camel@sipsolutions.net> (sfid-20160127_153356_502496_03234AF8)
Subject: Re: [RFC] mac80211: introduce netdev queue control for txqs
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 27 Jan 2016 15:33:49 +0100
In-Reply-To: <1453904917-25458-1-git-send-email-michal.kazior@tieto.com> (sfid-20160127_152732_241232_E83365C7)
References: <1453904917-25458-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160127_152732_241232_E83365C7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 15:28 +0100, Michal Kazior wrote:
> Until now all stations (notably in AP mode) would
> share 4 AC queues exposed via netdev. This meant
> that whenever a single station's AC became full
> all other stations' AC were considered full and
> stopped as well.
> 
> This was suboptimal and could lead to per station
> traffic starvation and/or suboptimal Tx
> aggregation performance.

I really think you need to Cc netdev on this :)

johannes

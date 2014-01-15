Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAONla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:41:30 -0500
Message-ID: <1389793286.4338.15.camel@jlt4.sipsolutions.net> (sfid-20140115_144133_077455_82C21417)
Subject: Re: [PATCH 3/3] cfg80211: Clean up connect params and channel
 fetching
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Jan 2014 14:41:26 +0100
In-Reply-To: <20140114220144.GA19710@w1.fi>
References: <20140114220144.GA19710@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 00:01 +0200, Jouni Malinen wrote:
> Addition of the frequency hints showed up couple of places in cfg80211
> where pointers could be marked const and a shared function could be used
> to fetch a valid channel.

Thanks, applied.

johannes


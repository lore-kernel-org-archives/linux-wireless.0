Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44932 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab0CVS2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 14:28:54 -0400
Subject: Re: [RFC PATCHv6 0/2] mac80211: cfg80211: Roam trigger support
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@nokia.com
In-Reply-To: <1269252943-2450-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1269252943-2450-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 11:28:58 -0700
Message-ID: <1269282538.7645.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-22 at 12:15 +0200, Juuso Oikarinen wrote:
> v6 of these patches incorporate more changes based on of Johannes' comments.
> Some parts of the code was refactored to improve extendability.
> 
> v6 also has fixes a problem in configuring the rssi threshold and hysteresis
> to the driver. It's now only done when associated.

I like it now :)

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes


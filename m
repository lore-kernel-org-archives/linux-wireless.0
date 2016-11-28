Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43318 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933373AbcK1Oca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 09:32:30 -0500
Message-ID: <1480343530.8107.51.camel@sipsolutions.net> (sfid-20161128_153302_508580_6F907520)
Subject: Re: [RFC V2 1/5] nl80211: allow reporting RTT information in scan
 results
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 28 Nov 2016 15:32:10 +0100
In-Reply-To: <1479388726-3288-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
         <1479388726-3288-2-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * @distance: distance to AP with %parent_bssid in centimeters. Zero
> + *	value indicates this is undetermined.
> + * @var_distance: variance of %distance indicating accurracy.

accuracy

The distance between the two APs? Where are you even obtaining that
information from?

johannes

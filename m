Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45724 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbbC3JI1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 05:08:27 -0400
Message-ID: <1427706503.26117.22.camel@sipsolutions.net> (sfid-20150330_110830_702642_8BA8DC5F)
Subject: Re: [PATCH] iw:  Print OSEN element for HotSpot 2.0 IE.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Mar 2015 11:08:23 +0200
In-Reply-To: <1426629753-16905-1-git-send-email-greearb@candelatech.com>
References: <1426629753-16905-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-17 at 15:02 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Re-uses most of the print-rsn logic since only the header
> differs.
> 
> Example output:
> ...
> 	HotSpot 2.0 OSEN:
> 		 * Group cipher: NO-GROUP
> 		 * Pairwise ciphers: CCMP
> 		 * Authentication suites: OSEN
> 		 * Capabilities: 16-PTKSA-RC 1-GTKSA-RC (0x000c)

Applied.

johannes


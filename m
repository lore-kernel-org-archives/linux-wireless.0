Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2IEONG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 10:13:06 -0400
Message-ID: <1346854421.4364.21.camel@jlt4.sipsolutions.net> (sfid-20120905_161311_557924_11707489)
Subject: Re: [PATCH] wext: include wireless event id when it has a size
 problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Wed, 05 Sep 2012 16:13:41 +0200
In-Reply-To: <1345812212-18778-1-git-send-email-arend@broadcom.com> (sfid-20120824_144347_019489_948E84F3)
References: <1345812212-18778-1-git-send-email-arend@broadcom.com>
	 (sfid-20120824_144347_019489_948E84F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-08-24 at 14:43 +0200, Arend van Spriel wrote:
> The wext code checks is the event data is within size limits.
> When this check fails a message is logged with violating size.
> This patch adds the event id to put us on the right track for
> resolving that violation.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Maybe wext is not popular, but I found the change helpful debugging
> so others may benefit from it. Still some wireless apps default to
> it, eg. wpa_supplicant.

I don't even want to know what you're debugging, but I applied it
anyway.

FWIW, wext isn't just "not popular", it's "pretty much dead" :-)

johannes


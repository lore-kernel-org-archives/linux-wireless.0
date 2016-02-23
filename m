Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59048 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbcBWJlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 04:41:03 -0500
Message-ID: <1456220460.2041.1.camel@sipsolutions.net> (sfid-20160223_104108_587558_23967930)
Subject: Re: [PATCH] nl80211: Zero out the connection keys memory when
 freeing them.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Tue, 23 Feb 2016 10:41:00 +0100
In-Reply-To: <1455148822-13849-1-git-send-email-ola1olsson@gmail.com> (sfid-20160211_010210_957740_6EF997E6)
References: <1455148822-13849-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20160211_010210_957740_6EF997E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-11 at 01:00 +0100, Ola Olsson wrote:
> The connection keys are zeroed out in all other cases except this
> one. Let's fix the last one as well.
> 
Applied.

johannes

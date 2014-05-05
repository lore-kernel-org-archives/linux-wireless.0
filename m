Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbaEEM7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 08:59:45 -0400
Message-ID: <1399294777.22235.12.camel@jlt4.sipsolutions.net> (sfid-20140505_145949_763379_2FCD70C4)
Subject: Re: [PATCH] mac80211: Fix mac80211 station info rx bitrate for IBSS
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 05 May 2014 14:59:37 +0200
In-Reply-To: <4194886.cHRlWHyH6L@desktop.local> (sfid-20140501_100349_231495_20566B7F)
References: <4194886.cHRlWHyH6L@desktop.local>
	 (sfid-20140501_100349_231495_20566B7F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-01 at 10:03 +0200, Henning Rogge wrote:
> From: Henning Rogge <hrogge@gmail.com>
> 
> Filter out incoming multicast packages before applying their bitrate
> to the rx bitrate station info field to prevent them from setting the
> rx bitrate to the basic multicast rate.

Applied, thanks.

johannes


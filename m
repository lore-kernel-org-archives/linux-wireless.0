Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab2LGINn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 03:13:43 -0500
Message-ID: <1354868041.9552.7.camel@jlt4.sipsolutions.net> (sfid-20121207_091347_333804_A9D9EEEF)
Subject: Re: [PATCH] mac80211: fix the multiple warnings for budding
 chipsets without ampdu_action defined
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya <chaitanyatk@posedge.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 07 Dec 2012 09:14:01 +0100
In-Reply-To: <50C1917E.2010407@posedge.com>
References: <201212070645.qB76jSjN013395@chaitanya-desktop>
	 <50C1917E.2010407@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-07 at 12:19 +0530, Chaitanya wrote:
> 
> Warn once should suffice.
> 
> Eg: our driver doesn't support the ampdu_action yet, so
> seeing a lot of warnings, hence the check for any

Yay, this worked. Applied with a changed commit log.

johannes


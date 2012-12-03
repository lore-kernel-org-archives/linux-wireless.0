Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2LCKYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 05:24:12 -0500
Message-ID: <1354530274.9717.1.camel@jlt4.sipsolutions.net> (sfid-20121203_112422_708354_33BC93C1)
Subject: Re: [RFC] cfg80211: fix channel error on mesh join
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 03 Dec 2012 11:24:34 +0100
In-Reply-To: <1354329009-25513-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1354329009-25513-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-30 at 18:30 -0800, Marco Porsch wrote:
> Fix an error on mesh join when no channel has been explicitly set beforehand.
> 
> Previously a WARN_ON was hit in cfg80211_reg_can_beacon because center_freq1
> was not set.
> 
> Also fix double semicolon.

Applied, but I moved the assignment down.

johannes


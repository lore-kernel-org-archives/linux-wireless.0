Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161475Ab3DENIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 09:08:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UO6Ng-0006R1-Id
	for linux-wireless@vger.kernel.org; Fri, 05 Apr 2013 15:08:36 +0200
Message-ID: <1365167313.8515.25.camel@jlt4.sipsolutions.net> (sfid-20130405_150841_493402_81161638)
Subject: Re: [PATCH 0/3] mac80211: fixes for do_stop while suspended
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 05 Apr 2013 15:08:33 +0200
In-Reply-To: <1364991920-11712-1-git-send-email-johannes@sipsolutions.net> (sfid-20130403_142528_316378_A6E9C1A9)
References: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
	 <1364991920-11712-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130403_142528_316378_A6E9C1A9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-03 at 14:25 +0200, Johannes Berg wrote:
> Inspired by Stanislaw's patches, I took another look. He tested my
> RFC series and while there were still issues it looks better now,
> so we're going to apply this. Speak up if you don't want that! :)

Applied.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1K1Pyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 10:54:49 -0500
Subject: Re: [PATCH 0/2] mac80211: use timeout from addba resp
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <CALGY4ftDBArahTTQAoy07Q+qjR2UtXJ7KETPk-rR33u+f0Radw@mail.gmail.com> (sfid-20111128_164510_312868_5C276B9E)
References: <1322432153-17425-1-git-send-email-mar.kolya@gmail.com>
	 <1322469030.4060.4.camel@jlt3.sipsolutions.net>
	 <CALGY4ftDBArahTTQAoy07Q+qjR2UtXJ7KETPk-rR33u+f0Radw@mail.gmail.com>
	 (sfid-20111128_164510_312868_5C276B9E)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 16:54:45 +0100
Message-ID: <1322495685.4060.7.camel@jlt3.sipsolutions.net> (sfid-20111128_165452_254549_EAD8BA10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 10:44 -0500, Nikolay Martynov wrote:

>  Sorry, about this. I just though that if addba resp contains timeout
> then there should be some use of it. If this goes against standard
> just disregard this patch.

Well, ok, I thought you checked and found we were doing it wrong :)

>  BTW, is it possible to download a copy of the standard or is it
> something I need to pay for/subscribe to?

Google for getieee 802.11.

johannes


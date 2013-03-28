Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3C1Prc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 11:47:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ULF34-0004Xs-JT
	for linux-wireless@vger.kernel.org; Thu, 28 Mar 2013 16:47:30 +0100
Message-ID: <1364485647.10397.8.camel@jlt4.sipsolutions.net> (sfid-20130328_164738_829495_DD2172F0)
Subject: Re: [PATCH 0/4] mac80211: IE parsing cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 28 Mar 2013 16:47:27 +0100
In-Reply-To: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net> (sfid-20130327_144008_758972_0F378272)
References: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130327_144008_758972_0F378272)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-27 at 14:39 +0100, Johannes Berg wrote:
> Remove some unused but parsed IEs, move length checks to make
> the parser struct smaller and use a struct for the TIE.

Applied.

johannes


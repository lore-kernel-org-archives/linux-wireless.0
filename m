Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2G0MbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 08:31:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SujhI-0007S4-KC
	for linux-wireless@vger.kernel.org; Fri, 27 Jul 2012 14:31:12 +0200
Message-ID: <1343392271.4449.13.camel@jlt3.sipsolutions.net> (sfid-20120727_143117_313492_D1A6B03A)
Subject: Re: [RFC 00/20] mac80211: multi-channel work
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 27 Jul 2012 14:31:11 +0200
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131724_863712_473E357A)
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120727_131724_863712_473E357A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 13:16 +0200, Johannes Berg wrote:

> Comments welcome!

I should've mentioned what's left to do for me:

 * figure out channel-switch handling, right now it's just #if'ed out
 * restore TX power settings, but should it be be per vif, per chanctx
   or something else?
 * test test test :)

johannes


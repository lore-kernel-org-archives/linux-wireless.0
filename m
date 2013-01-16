Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3APW5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 17:57:15 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tvbuz-0003LO-Oz
	for linux-wireless@vger.kernel.org; Wed, 16 Jan 2013 23:57:14 +0100
Message-ID: <1358377061.15012.43.camel@jlt4.sipsolutions.net> (sfid-20130116_235722_149810_7528CB37)
Subject: Re: [PATCH] mac80211: split out chandef tracing macros
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 16 Jan 2013 23:57:41 +0100
In-Reply-To: <1356636777-16051-1-git-send-email-johannes@sipsolutions.net> (sfid-20121227_203238_991567_1922812C)
References: <1356636777-16051-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121227_203238_991567_1922812C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-27 at 20:32 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Some new APIs will require tracing a chandef without
> it being part of a channel context, so separate out
> the tracing macros for that.

Applied.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37464 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934098Ab3BMPh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 10:37:57 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20763.45827.549496.955059@gargle.gargle.HOWL> (sfid-20130213_163802_406567_A1340764)
Date: Wed, 13 Feb 2013 21:06:35 +0530
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: start auth/assoc timeout on frame status
In-Reply-To: <511BAF4D.7090706@neratec.com>
References: <1359638935-16613-1-git-send-email-johannes@sipsolutions.net>
	<1359992600.10311.25.camel@jlt4.sipsolutions.net>
	<511B9807.6000200@neratec.com>
	<1360765274.8868.13.camel@jlt4.sipsolutions.net>
	<511BA1E5.40402@neratec.com>
	<1360765934.8868.14.camel@jlt4.sipsolutions.net>
	<1360766384.8868.15.camel@jlt4.sipsolutions.net>
	<511BAF4D.7090706@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik wrote:
> I don't see anymore timeouts. Sometimes station tries to authenticate,
> sends direct probe, timeouts and then goes again with auth message.

If you are using ath9k_rate_control, can you check if you still see the issue
with minstrel_ht ?

Sujith

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2J3Iby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 04:31:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TT7Em-00077V-Sk
	for linux-wireless@vger.kernel.org; Tue, 30 Oct 2012 09:31:53 +0100
Message-ID: <1351585903.10097.4.camel@jlt4.sipsolutions.net> (sfid-20121030_093159_374629_4A34D375)
Subject: Re: [PATCH] mac80211_hwsim: allow using channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 30 Oct 2012 09:31:43 +0100
In-Reply-To: <1351243524-18566-1-git-send-email-johannes@sipsolutions.net> (sfid-20121026_112616_221941_F360B320)
References: <1351243524-18566-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121026_112616_221941_F360B320)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 11:25 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> To use mac80211_hwsim for testing channel contexts it
> has to support them, and for that it has to support
> hw scan and hw-remain-on-channel.
> 
> Since it's pure software, the off-channel activities
> are really not off-channel but listening and sending
> on a second channel. Also, the multi-channel isn't
> really doing TDM, it's just on both channels at the
> same time.
> 
> For testing purposes, you can specify the number of
> concurrent channels with a module parameter, it is
> set to one by default. When set to two or more, the
> userspace API for wmediumd is disabled as it has no
> provisions for multi-channel yet.

Applied.

johannes


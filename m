Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2HTL5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:57:34 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T3Qbt-0005ZO-48
	for linux-wireless@vger.kernel.org; Mon, 20 Aug 2012 13:57:33 +0200
Message-ID: <1345463850.4459.20.camel@jlt3.sipsolutions.net> (sfid-20120820_135738_267955_2EA80469)
Subject: Re: [RFC 0/8] channel switch improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 13:57:30 +0200
In-Reply-To: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172135_485039_3F6BF73C)
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120801_172135_485039_3F6BF73C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 17:21 +0200, Johannes Berg wrote:
> mac80211 currently doesn't support extended channel switch
> and also doesn't handle failures well.
> 
> Support extended channel switch when the operating class 
> is one of the global operating classes, and handle any
> failures by disconnecting from the network.
> 
> This is completely untested so far, does anyone have a
> good test environment for this kind of thing?

Since they're just cleanups, I applied the first five patches. The rest
need to be tested and validated more etc.

johannes


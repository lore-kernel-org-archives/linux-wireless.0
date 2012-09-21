Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2IUOMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 10:12:44 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TF3yE-0006RQ-Oe
	for linux-wireless@vger.kernel.org; Fri, 21 Sep 2012 16:12:42 +0200
Message-ID: <1348236800.4160.12.camel@jlt4.sipsolutions.net> (sfid-20120921_161247_134958_4AFF6297)
Subject: Re: [PATCH 0/3] mac80211: avoid useless delBA frames
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 21 Sep 2012 16:13:20 +0200
In-Reply-To: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net> (sfid-20120919_120800_557148_51638D1E)
References: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120919_120800_557148_51638D1E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-19 at 12:08 +0200, Johannes Berg wrote:
> There are a few situations where it's completely pointless
> to send delBA action frames, so let's remove them.

Applied all three.

johannes


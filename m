Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2JAH2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 03:28:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TIaQN-0005TY-AR
	for linux-wireless@vger.kernel.org; Mon, 01 Oct 2012 09:28:19 +0200
Message-ID: <1349076530.10330.6.camel@jlt4.sipsolutions.net> (sfid-20121001_092825_931793_0605448B)
Subject: Re: [PATCH 00/10] mac80211 multi-channel work (final?)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Oct 2012 09:28:50 +0200
In-Reply-To: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net> (sfid-20120914_143641_493953_B2559877)
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120914_143641_493953_B2559877)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I also don't intend to merge this for 3.7, it's late in the
> cycle now and the merge window will open soon, I'd rather
> have a little more time to let this be sorted out, and also
> for the TX power issue. I'll put it into mac80211-next as
> soon as the merge window opens, until then you can find it
> in the 'wip' branch of my mac80211-next tree.

I've applied this now, I'll have to sort out the TX power thing before
we merge any driver actually using it, but I expect that'll be a while
anyway.

johannes


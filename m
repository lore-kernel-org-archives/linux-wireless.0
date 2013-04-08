Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761958Ab3DHJGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 05:06:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UP81m-0001PR-O0
	for linux-wireless@vger.kernel.org; Mon, 08 Apr 2013 11:06:15 +0200
Message-ID: <1365411972.25475.1.camel@jlt4.sipsolutions.net> (sfid-20130408_110619_827387_BBE3E07C)
Subject: Re: [PATCH 0/3] mac80211: some queue management fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 08 Apr 2013 11:06:12 +0200
In-Reply-To: <1364485596-30425-1-git-send-email-johannes@sipsolutions.net> (sfid-20130328_164648_885369_AA2F3975)
References: <1364485596-30425-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130328_164648_885369_AA2F3975)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-28 at 16:46 +0100, Johannes Berg wrote:
> I let these run through some testing, and it seems fine. The actual
> error conditions are hard to test though -- particularly for the last
> patch, most likely nobody ever saw that.

All applied.

johannes


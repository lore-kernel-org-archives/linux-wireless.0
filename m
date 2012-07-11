Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2GKJb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 05:31:58 -0400
Message-ID: <1341999114.4480.15.camel@jlt3.sipsolutions.net> (sfid-20120711_113202_655526_13E393CF)
Subject: Re: [PATCH] mac80211: Fix the Problem of Unreachable Mesh STA from
 DS
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Wed, 11 Jul 2012 11:31:54 +0200
In-Reply-To: <CAEFj986xt62YUw9vEEc+qdor1_7mLR9pmKqyc_pnDeuDEjxL2A@mail.gmail.com> (sfid-20120711_110344_246207_8046DF54)
References: <1341995301-24611-1-git-send-email-yeohchunyeow@gmail.com>
	 <1341996025.4480.11.camel@jlt3.sipsolutions.net>
	 <CAEFj986xt62YUw9vEEc+qdor1_7mLR9pmKqyc_pnDeuDEjxL2A@mail.gmail.com>
	 (sfid-20120711_110344_246207_8046DF54)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-11 at 17:03 +0800, Yeoh Chun-Yeow wrote:
> > Is this relevant for any tree other than mac80211-next?
> The previous patch is already inside the compat-wireless 3.5 stable releases.

So this should be applied to 3.5?

johannes


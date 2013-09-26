Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:53364 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756419Ab3IZLJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 07:09:49 -0400
Date: Thu, 26 Sep 2013 14:09:34 +0300
From: Jouni Malinen <j@w1.fi>
To: Chet Lanctot <clanctot@codeaurora.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/2] nl80211/cfg80211: Support PMF on drivers with
 integrated AP SME
Message-ID: <20130926110934.GA5070@w1.fi> (sfid-20130926_130952_579317_6B8EFCD7)
References: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 17, 2013 at 12:31:34PM -0700, Chet Lanctot wrote:
> These patches represent a small number of changes to the
> nl80211/cfg80211 interface to support Protected Management Frames
> (PMF, 802.11w) on an AP.  Specifically, these changes are needed for
> drivers that have the AP SME integrated.
> 
> Support is added for drivers that do not implement the SA Query procedure
> that is part of PMF.  Instead, the need for upper layer software to
> do this procedure is advertised.  And support is added so that  whether
> PMF should be used for station connections is communicated to the driver.

The patches here have some issues in not compiling and formatting
(trailing whitespace) and as such, cannot be applied as-is. I'd expect a
new version to be posted to address those issues.

That said, if there is any feedback on the general direction used here,
that would obviously be welcome even before the updated patches are
posted.

-- 
Jouni Malinen                                            PGP id EFC895FA

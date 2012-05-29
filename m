Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab2E2HKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 03:10:37 -0400
Message-ID: <1338275441.4342.20.camel@jlt3.sipsolutions.net> (sfid-20120529_091041_092854_E2977387)
Subject: Re: [PATCH 1/2] nl80211/cfg80211: add scan channel times to scan
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 09:10:41 +0200
In-Reply-To: <1337885569-32711-1-git-send-email-victorg@ti.com>
References: <1337885569-32711-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-24 at 21:52 +0300, Victor Goldenshtein wrote:
> In order to give the usermode an ability to configure
> scan channel times, and as it required for the beacon
> reports in the 802.11k standard.
> 
> Add to the scan command min/max channel times. Add
> min/max passive channel times, since a single scan
> can contain both passive and active channels due to
> regulatory constraints.

I think there may have to be some feature flag for this since otherwise
you can't know whether you're going to be implementing 11k properly or
not.

johannes


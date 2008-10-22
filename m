Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58078 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYJVVTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 17:19:42 -0400
Date: Wed, 22 Oct 2008 17:18:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3 v3] p54: more definitions form lmac_longbow.h and
	pda.h
Message-ID: <20081022211856.GK15808@tuxdriver.com> (sfid-20081022_231947_105074_56ECB3E6)
References: <200810170114.45742.chunkeey@web.de> <200810182318.01334.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810182318.01334.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 18, 2008 at 11:18:01PM +0200, Christian Lamparter wrote:
> This patch ports more useful features to p54
>   - PDR definitions for the synth chips & regulatory domain.
>   - honour IEEE80211_TX_CTL_ASSIGN_SEQ flag, if it's set.
>   - adds some lost mutex_lock & mutex_unlock.
>   - replace two more "magic values" that sneaked past.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

This doesn't seem to apply -- am I missing a patch?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2LMODw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:52 -0500
Message-ID: <1355407454.9463.5.camel@jlt4.sipsolutions.net> (sfid-20121213_160117_692009_EE090D5B)
Subject: Re: [PATCH] mac80211: Allow disabling SGI-20.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Dec 2012 15:04:14 +0100
In-Reply-To: <1355360180-19295-1-git-send-email-greearb@candelatech.com> (sfid-20121213_015637_703359_E9A35183)
References: <1355360180-19295-1-git-send-email-greearb@candelatech.com>
	 (sfid-20121213_015637_703359_E9A35183)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 16:56 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This allows user-space (wpa_supplicant) to disable
> short guard interval (SGI) for 20Mhz.  The SGI-40
> disable option is already handled.

Applied.

Caveat as before, I'm going to have to rebase my trees once the merge
window concludes.

johannes


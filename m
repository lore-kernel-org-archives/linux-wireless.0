Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0LHILq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 03:11:46 -0500
Subject: Re: [PATCH] wireless: Remove spurious warning in mlme.c
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291759599-14698-1-git-send-email-greearb@candelatech.com>
References: <1291759599-14698-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 09:11:43 +0100
Message-ID: <1291795903.3562.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 14:06 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Seems that we should not be warning if all of the
> authtry_bsses are already NULL.

Do you keep running into the warning? I'd really like to understand how
it happens -- it seems to point to a mac80211 bug.

So don't really like this patch.

johannes


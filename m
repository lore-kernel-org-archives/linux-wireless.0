Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1J1INZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 04:13:25 -0400
Subject: Re: [wireless-next PATCH 5/5] wifi-debugfs: Fix AMSDU rate
 printout.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319778680-11405-5-git-send-email-greearb@candelatech.com> (sfid-20111028_071211_282287_FE1890EF)
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 <1319778680-11405-5-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071211_282287_FE1890EF)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 10:13:22 +0200
Message-ID: <1319789602.3914.17.camel@jlt3.sipsolutions.net> (sfid-20111028_101328_473110_79F5499E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> It was flipped.  See section 7.3.2.56 of the 802.11n
> spec for details.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

johannes



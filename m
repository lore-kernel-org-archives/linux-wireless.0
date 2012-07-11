Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab2GKIka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 04:40:30 -0400
Message-ID: <1341996025.4480.11.camel@jlt3.sipsolutions.net> (sfid-20120711_104036_479773_BD733EED)
Subject: Re: [PATCH] mac80211: Fix the Problem of Unreachable Mesh STA from
 DS
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Wed, 11 Jul 2012 10:40:25 +0200
In-Reply-To: <1341995301-24611-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120711_102904_766340_6B5496BC)
References: <1341995301-24611-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120711_102904_766340_6B5496BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-11 at 16:28 +0800, Chun-Yeow Yeoh wrote:
> This patch fixes the problem of unreachable mesh STA from
> Distribution System (DS) due to the introduction of previous
> patch solving the mesh STA joining from one MBSS to another
> MBSS.

Is this relevant for any tree other than mac80211-next?

johannes


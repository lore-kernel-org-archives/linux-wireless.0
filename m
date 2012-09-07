Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760360Ab2IGLvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 07:51:35 -0400
Message-ID: <1347018732.4256.13.camel@jlt4.sipsolutions.net> (sfid-20120907_135206_134007_E7ECEBB0)
Subject: Re: [PATCH 2/2] mac80211: reply to AUTH frame with a DEAUTH if sta
 allocation fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 13:52:12 +0200
In-Reply-To: <1347017333-13497-2-git-send-email-ordex@autistici.org>
References: <1347017333-13497-1-git-send-email-ordex@autistici.org>
	 <1347017333-13497-2-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 13:28 +0200, Antonio Quartulli wrote:
> Whenever a host gets an AUTH frame it first allocates a new station and then
> replies with another AUTH frame. However, if sta allocations fails the host
> should send a DEAUTH frame instead to tell the other end that something went
> wrong

Applied both, but I reworded the commit messages a bit and broke lines
to less than 72 chars as recommended.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2FIIdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:33:39 -0400
Message-ID: <1339230816.4539.22.camel@jlt3.sipsolutions.net> (sfid-20120609_103352_288435_7385B376)
Subject: Re: [PATCH] cfg80211: check iface combinations only when iface is
 running
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Jun 2012 10:33:36 +0200
In-Reply-To: <1339145744-9154-1-git-send-email-michal.kazior@tieto.com>
References: <1339145744-9154-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 10:55 +0200, Michal Kazior wrote:
> Don't validate interface combinations on a stopped
> interface. Otherwise we might end up being able to
> create a new interface with a certain type, but
> won't be able to change an existing interface
> into that type.
> 
> This also skips some other functions when
> interface is stopped and changing interface type.

Applied for 3.5

johannes



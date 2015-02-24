Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38004 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbbBXJ7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 04:59:12 -0500
Message-ID: <1424771944.2192.10.camel@sipsolutions.net> (sfid-20150224_105952_279817_B1EEFECA)
Subject: Re: [PATCH] cfg80211: fix n_reg_rules to match world_regdom
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Abele <jason.abele@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 10:59:04 +0100
In-Reply-To: <1424218241-15747-1-git-send-email-jason.abele@gmail.com> (sfid-20150218_011230_325572_8E3C9617)
References: <1424218241-15747-1-git-send-email-jason.abele@gmail.com>
	 (sfid-20150218_011230_325572_8E3C9617)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-17 at 16:10 -0800, Jason Abele wrote:
> From: Jason Abele <jason@aether.com>
> 
> There are currently 8 rules in the world_regdom, but only the first 6
> are applied due to an incorrect value for n_reg_rules.  This causes
> channels 149-165 and 60GHz to be disabled.

Applied, thanks.

johannes


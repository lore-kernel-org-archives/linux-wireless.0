Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41373 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaK1Non (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 08:44:43 -0500
Message-ID: <1417182278.27562.6.camel@sipsolutions.net> (sfid-20141128_144446_468202_6ADE7474)
Subject: Re: [PATCH v5 1/4] cfg80211: leave invalid channels on regdomain
 change
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 28 Nov 2014 14:44:38 +0100
In-Reply-To: <1417074298-12254-1-git-send-email-arik@wizery.com> (sfid-20141127_084458_008782_038693EB)
References: <1417074298-12254-1-git-send-email-arik@wizery.com>
	 (sfid-20141127_084458_008782_038693EB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-27 at 09:44 +0200, Arik Nemtsov wrote:
> When the regulatory settings change, some channels might become invalid.
> Disconnect interfaces acting on these channels, after giving userspace
> code a grace period to leave them.
> 
> This mode is currently opt-in, and not all interface operating modes are
> supported for regulatory-enforcement checks. A wiphy that wishes to use
> the new enforcement code must specify an appropriate regulatory flag,
> and all its supported interface modes must be supported by the chekcing
> code.

Applied, with some trivial changes.

johannes


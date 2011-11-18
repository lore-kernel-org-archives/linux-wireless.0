Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab1KRKE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 05:04:27 -0500
Subject: Re: [PATCH v9 1/2] wireless:  Support ht-capabilities over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1321566884-31757-1-git-send-email-greearb@candelatech.com> (sfid-20111117_225454_269234_8D9DA167)
References: <1321566884-31757-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111117_225454_269234_8D9DA167)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 11:04:23 +0100
Message-ID: <1321610663.10266.20.camel@jlt3.sipsolutions.net> (sfid-20111118_110432_333316_1A70B1BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-17 at 13:54 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This allows users to disable features such as HT, HT40,
> and to modify the MCS, AMPDU, and AMSDU settings for
> drivers that support it.
> 
> The MCS, AMPDU, and AMSDU features that may be disabled are
> are reported in the phy-info netlink message as a mask.
> 
> Attemping to disable features that are not supported will
> take no affect, but will not return errors.  This is to aid
> backwards compatibility in user-space apps that may not be
> clever enough to deal with parsing the the capabilities mask.
> 
> This patch only enables the infrastructure.  An additional
> patch will enable the feature in mac80211.

Looks OK to me.

johannes


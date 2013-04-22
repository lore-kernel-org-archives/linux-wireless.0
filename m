Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3DVNgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:36:15 -0400
Message-ID: <1366637768.8637.11.camel@jlt4.sipsolutions.net> (sfid-20130422_153619_009167_163F3E4B)
Subject: Re: [PATCH] nl80211: allow using wdev identifiers to get scan
 results
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: david.spinadel@intel.com, arend@broadcom.com
Date: Mon, 22 Apr 2013 15:36:08 +0200
In-Reply-To: <1366326266-19783-1-git-send-email-johannes@sipsolutions.net> (sfid-20130419_010438_313582_6CFC095E)
References: <1366326266-19783-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130419_010438_313582_6CFC095E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-19 at 01:04 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Most dump callbacks, including the scan results one, use
> the netdev to identify what to do, which is incorrect for
> the P2P_DEVICE support, it needs to be able to get the
> scan result from the wdev. Change all dumps to unify the
> code, but ones other than scan don't really support being
> executed on a wdev that has no netdev.

Applied.

johannes


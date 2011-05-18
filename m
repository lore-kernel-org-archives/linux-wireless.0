Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1ERW7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 18:59:45 -0400
Subject: Re: [PATCH v2] wireless: Support can-scan-one logic.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305586296-23147-1-git-send-email-greearb@candelatech.com> (sfid-20110517_005202_689056_9240F1AF)
References: <1305586296-23147-1-git-send-email-greearb@candelatech.com>
	 (sfid-20110517_005202_689056_9240F1AF)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 16:02:18 -0700
Message-ID: <1305759738.8827.6.camel@jlt3.sipsolutions.net> (sfid-20110519_005948_566247_EE663E73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-16 at 15:51 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Enable this by passing a -1 for a scan frequency.

I still don't think we should do that, especially not with -1. That's
totally non-netlink like inband signalling. I'll also reply to your
other mail though since I don't think it makes sense to have this sort
of convenience function in the kernel.

johannes


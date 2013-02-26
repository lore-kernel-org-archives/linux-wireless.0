Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661Ab3BZVrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 16:47:16 -0500
Message-ID: <1361915231.8440.28.camel@jlt4.sipsolutions.net> (sfid-20130226_224729_841823_70E3C315)
Subject: Re: [PATCH v2 1/2] mac80211:  Stop timers before canceling work
 items.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Feb 2013 22:47:11 +0100
In-Reply-To: <1361382069-31729-1-git-send-email-greearb@candelatech.com> (sfid-20130220_184123_653697_BABBBF90)
References: <1361382069-31729-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130220_184123_653697_BABBBF90)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-20 at 09:41 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Re-order the quiesce code so that timers are
> always stopped before work-items are flushed.  This was
> not the problem I saw, but I think it may still be more
> correct.

Applied both, adding Cc stable.

johannes


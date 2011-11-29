Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1K2Iv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 03:51:58 -0500
Subject: Re: [PATCH v3] iw: Support ht-capability overrides mask.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1322505622-13446-1-git-send-email-greearb@candelatech.com> (sfid-20111128_194043_702798_6A11361F)
References: <1322505622-13446-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111128_194043_702798_6A11361F)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 09:51:54 +0100
Message-ID: <1322556714.4110.13.camel@jlt3.sipsolutions.net> (sfid-20111129_095201_431742_2E67C91C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 10:40 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Let user know which capabilities are supported.

I applied this with a bunch of modifications, but I think you should
follow up and make it more complete. You're covering exactly and only
the case that you're working on right now, I don't think that's good
practice.

johannes


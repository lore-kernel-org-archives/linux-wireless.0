Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36625 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab0HYVOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 17:14:42 -0400
Date: Wed, 25 Aug 2010 17:10:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/6] "runtime" iftype switching
Message-ID: <20100825211036.GO2557@tuxdriver.com>
References: <20100825205619.152295081@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100825205619.152295081@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 25, 2010 at 10:56:19PM +0200, Johannes Berg wrote:
> Here's some code to allow runtime (while the
> interface is UP) interface type switching,
> so far only for STA, IBSS and AP because the
> others seem a bit trickier and harder to
> verify.
> 
> Comments welcome. Not tested with HW yet :)

What is driving this?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

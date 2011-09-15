Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab1IOJT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:19:56 -0400
Subject: Re: [RFC] wireless: Fix rate mask for scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316078358.3992.4.camel@jlt3.sipsolutions.net> (sfid-20110915_111925_539359_787BCAA8)
References: <1316078089-7221-1-git-send-email-rmanohar@qca.qualcomm.com>
	 <1316078358.3992.4.camel@jlt3.sipsolutions.net>
	 (sfid-20110915_111925_539359_787BCAA8)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 11:19:54 +0200
Message-ID: <1316078394.3992.5.camel@jlt3.sipsolutions.net> (sfid-20110915_111958_828409_2BAF580C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 11:19 +0200, Johannes Berg wrote:

> Also, CC stable doesn't work that way -- you don't CC them, you just
> write into it "Cc: stable@kernel.org". This makes them pick out the
> patch later once it got applied.

Never mind, I see you did do it that way, I guess git just picked it up
and sent a copy too.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab2JaPEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 11:04:07 -0400
Message-ID: <1351695876.10946.1.camel@jlt4.sipsolutions.net> (sfid-20121031_160415_336549_ACA60C1E)
Subject: Re: [PATCH v2 1/2] wireless: Driver for 60GHz card wil6210
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 31 Oct 2012 16:04:36 +0100
In-Reply-To: <1952560.nYyRnDKWFr@lx-vladimir>
References: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1578864.KppKrIJQWb@lx-vladimir>
	 <1351693661.10946.0.camel@jlt4.sipsolutions.net>
	 <1952560.nYyRnDKWFr@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-31 at 17:00 +0200, Vladimir Kondratiev wrote:

> you just proved reason to be CC'ed: you give valuable feedback :-)

:)

> Oh, no! Usually, you start digging into ISR registers when something stalled 
> when it should not. At this point, you want to discover that, for example, 
> some interrupt bit not came up. Then, you may try to manually set it writing 
> into register. If you trace, it will flood dmesg, impacting performance, in 
> normal situation; and will not let you analyze and recover from abnormal one.

Well I wasn't thinking printk, but rather trace events, so you can
record it to the buffer and not have the big overhead etc.

> I need "manual control" here.

Fair enough.

johannes


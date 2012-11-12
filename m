Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:60022 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab2KLPBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 10:01:14 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>, <j@w1.fi>
Subject: Re: 60 GHz interface types (was: [PATCH v5 1/2] wireless: Driver for 60GHz card wil6210)
Date: Mon, 12 Nov 2012 17:01:10 +0200
Message-ID: <6324890.n28cQKm0cl@lx-vladimir> (sfid-20121112_160117_813979_741C0214)
In-Reply-To: <1352715356.9525.12.camel@jlt4.sipsolutions.net>
References: <1351701417-3140-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <9805542.8YLh3g7mqN@lx-vladimir> <1352715356.9525.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, November 12, 2012 11:15:56 AM Johannes Berg wrote:
> Should it really (ab)use the AP interface type then? I'd argue we should
> get this right from the start, rather than fudging it, and then maybe
> having some kernel that has it wrong and userspace having to handle that
> etc.?

No, we should not. Right way is to add PBSS as BSS type.

I will describe PBSS in separate mail.

Thanks, Vladimir

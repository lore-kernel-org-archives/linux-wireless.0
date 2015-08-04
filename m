Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.iliad.fr ([212.27.33.1]:53501 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbbHDWJ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 18:09:59 -0400
Date: Wed, 5 Aug 2015 00:09:56 +0200
From: Maxime Bizon <mbizon@freebox.fr>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
Message-ID: <20150804220956.GA28583@sakura.staff.proxad.net> (sfid-20150805_001002_211073_08BA5F1A)
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <1436455659.36587.131.camel@sakura.staff.proxad.net>
 <87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tuesday 04 Aug 2015 à 20:02:23 (+0300), Kalle Valo wrote:

> I haven't looked at the driver myself yet. Do you have any estimates how
> much duplication there is?

ok the thing is I happen to know a bit about the chipset internals and
so it's easy for me to know that having a common driver is do-able.

so I may be biased, and I guess someone else should have a quick
glance at both driver code.

-- 
Maxime

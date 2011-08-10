Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:59970 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab1HJRTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 13:19:11 -0400
Date: Wed, 10 Aug 2011 19:15:15 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] b43: fix DMA on some bugged hardware
Message-ID: <20110810191515.1cb11eb1@milhouse> (sfid-20110810_191914_654337_A4D3313D)
In-Reply-To: <CACna6rz0m7SDT=gn26yGQYa6w4KghabCcK8QfM_NmJmpgN2gcg@mail.gmail.com>
References: <1312992688-6976-1-git-send-email-zajec5@gmail.com>
	<1312992688-6976-2-git-send-email-zajec5@gmail.com>
	<20110810183339.7259d936@milhouse>
	<CACna6rxNV-d_YNrCOqFCz8cbmbiXh-OqOYkvYmXacJCHsJ74-g@mail.gmail.com>
	<20110810185534.5f4b9db9@milhouse>
	<CACna6rz0m7SDT=gn26yGQYa6w4KghabCcK8QfM_NmJmpgN2gcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> kernel offers me addresses like:
> 0x000000001f310000

Yeah and that's why you didn't trigger the bug in the patch.
Extension is zero for both cases (low and high).

-- 
Greetings, Michael.

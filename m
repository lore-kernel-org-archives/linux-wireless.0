Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38151 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab2KMLUp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 06:20:45 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k_hw: Update AR9485 initvals
References: <1352698004-10790-1-git-send-email-sujith@msujith.org>
	<87pq3iy1mr.fsf@purkki.adurom.net>
	<20641.31202.323483.191549@gargle.gargle.HOWL>
Date: Tue, 13 Nov 2012 13:20:38 +0200
In-Reply-To: <20641.31202.323483.191549@gargle.gargle.HOWL> (Sujith
	Manoharan's message of "Tue, 13 Nov 2012 04:06:18 +0530")
Message-ID: <87lie5ycjd.fsf@purkki.adurom.net> (sfid-20121113_122051_202356_69404B6E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> This doesn't answer the most important question "Why?". For example,
>> does it fix something, is it just a synch up to get up-to-date with the
>> system team or something else?
>
> A sync - almost a year's backlog of changes.

Ok, makes sense. But you should document in the commit log so that
people understand what's happening and if there's a need to backport
etc.

-- 
Kalle Valo

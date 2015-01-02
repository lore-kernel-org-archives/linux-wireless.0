Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56747 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbABKlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2015 05:41:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21670.30281.688316.623369@gargle.gargle.HOWL> (sfid-20150102_114117_416939_37233614)
Date: Fri, 2 Jan 2015 16:13:21 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Enable RX batching
In-Reply-To: <87bnmh5zyh.fsf@kamboji.qca.qualcomm.com>
References: <1419834084-11859-1-git-send-email-sujith@msujith.org>
	<87fvbt62x9.fsf@kamboji.qca.qualcomm.com>
	<21670.22986.926659.849716@gargle.gargle.HOWL>
	<87bnmh5zyh.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> > Along with the other patch and an internal fix,
> > UDP RX increased to about 950 Mbps.
> 
> What was the number before?

It was about 600 Mbps. Maybe slightly higher, but the CPU
was maxed out by the torrent of tasklets trying to
replenish HTT buffers.

Sujith

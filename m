Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52226 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbABIjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2015 03:39:39 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21670.22986.926659.849716@gargle.gargle.HOWL> (sfid-20150102_095024_950057_48C9971B)
Date: Fri, 2 Jan 2015 14:11:46 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Enable RX batching
In-Reply-To: <87fvbt62x9.fsf@kamboji.qca.qualcomm.com>
References: <1419834084-11859-1-git-send-email-sujith@msujith.org>
	<87fvbt62x9.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Any throughput improvements?

Along with the other patch and an internal fix,
UDP RX increased to about 950 Mbps.

Sujith

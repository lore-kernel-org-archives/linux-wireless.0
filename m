Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53175 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbbBDHTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 02:19:51 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: <ath10k@lists.infradead.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Use TX cksum offload only for CHECKSUM_PARTIAL
References: <1422441092-29243-1-git-send-email-helmut.schaa@googlemail.com>
Date: Wed, 4 Feb 2015 09:19:37 +0200
In-Reply-To: <1422441092-29243-1-git-send-email-helmut.schaa@googlemail.com>
	(Helmut Schaa's message of "Wed, 28 Jan 2015 11:31:32 +0100")
Message-ID: <8761biw3cm.fsf@kamboji.qca.qualcomm.com> (sfid-20150204_081959_002445_508FB1AB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

> Otherwise ath10k will just checksum everything even if it did not
> go through the TCP/IP stack (for example bridged frames). In the worst
> case this could mean recreating the checksum for incorrect data.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Thanks, applied to ath.git.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43843 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbbKLT6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 14:58:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Borja Salazar <borja.salazar@fon.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: incorrect queue may be stopped/awaken
References: <1446572241-2246-1-git-send-email-borja.salazar@fon.com>
Date: Thu, 12 Nov 2015 21:57:53 +0200
In-Reply-To: <1446572241-2246-1-git-send-email-borja.salazar@fon.com> (Borja
	Salazar's message of "Tue, 3 Nov 2015 18:37:21 +0100")
Message-ID: <87611756ta.fsf@kamboji.qca.qualcomm.com> (sfid-20151112_205804_641972_C7BEDCA2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Borja Salazar <borja.salazar@fon.com> writes:

> When channel context is enabled, we could be
> stopping/awakening an incorrect queue.

Signed-off-by line is missing, I can't take this.

-- 
Kalle Valo

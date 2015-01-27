Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:41322 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbbA0OXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:23:22 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: disable irqs after fw crash
References: <1421749603-11424-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 16:23:10 +0200
In-Reply-To: <1421749603-11424-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 20 Jan 2015 11:26:43 +0100")
Message-ID: <87a914b8vl.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_152325_082417_28B47D09)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It makes little sense to keep handling irqs if fw
> is dead.
>
> This prevents multiple fw register dumps upon
> crash on some devices (seen on QCA6174).
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath.git.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9516 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaAJKXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 05:23:07 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH] ath10k: implement and use new beacon method
References: <1389287073-10939-1-git-send-email-marek.puzyniak@tieto.com>
Date: Fri, 10 Jan 2014 12:23:01 +0200
In-Reply-To: <1389287073-10939-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Thu, 9 Jan 2014 18:04:33 +0100")
Message-ID: <878uuo9lve.fsf@kamboji.qca.qualcomm.com> (sfid-20140110_112323_189818_3129BC52)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> From: Michal Kazior <michal.kazior@tieto.com>
>
> Until now ath10k used a copy-by-value beacon
> submission.
>
> The new method passes a DMA address via WMI
> command only. This command contains additional
> metadata that fixes AP behaviour with regard
> to powersave buffering.
>
> This also fixes strange bug when multicast traffic
> would freeze TX indefinitely.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>

Same here, also so few conflicts. Please check:

https://github.com/kvalo/ath/commit/b700fa4a953b3f01ee5ff167fb94943de13d6b34

-- 
Kalle Valo

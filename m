Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34003 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3HBGbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 02:31:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: implement checksum offloading
References: <1375260477-17030-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 2 Aug 2013 09:31:33 +0300
In-Reply-To: <1375260477-17030-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 31 Jul 2013 10:47:55 +0200")
Message-ID: <87vc3oppru.fsf@kamboji.qca.qualcomm.com> (sfid-20130802_083147_649651_027FAF7A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset adds tx and rx checksum offloading
> to ath10k driver.
>
> I don't have any hard numbers but I did observe a
> consistently sligthly better performance on AP135
> + ath10k. Nothing ground breaking though.
>
>
> Michal Kazior (2):
>   ath10k: implement rx checksum offloading
>   ath10k: implement tx checksum offloading

Applied, thanks.

-- 
Kalle Valo

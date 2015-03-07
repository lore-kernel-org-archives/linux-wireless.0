Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16708 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbbCGHyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 02:54:00 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: increase duty cycle maximum limit
References: <1424368506-18193-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Sat, 7 Mar 2015 09:53:51 +0200
In-Reply-To: <1424368506-18193-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 19 Feb 2015 23:25:05 +0530")
Message-ID: <87a8zp1bw0.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_085403_485887_7FDD031F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Allow user to configure the duty cycle upto 100%. Since thermal
> mitigation algorithm is running in user space, remove the driver
> level limitation and let the user to control the temperature.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, patch 1 applied. And I dropped patch 2 as you requested.

-- 
Kalle Valo

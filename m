Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8260 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbJ2K7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 06:59:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] ath10k: remove shadow copy engine descriptors
References: <1445603466-14138-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 29 Oct 2015 12:59:33 +0200
In-Reply-To: <1445603466-14138-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 23 Oct 2015 18:01:02 +0530")
Message-ID: <87k2q6q6sq.fsf@kamboji.qca.qualcomm.com> (sfid-20151029_115954_275622_45C51C8E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Below series remove shadow copy of CE descriptors for source ring.
> Removing the shadow copy should reduce d-cache pressure and memory
> usage of the driver.
>
> v2:
>  * Since ce_send is not using shadow, fix send completion as well.
>
> Rajkumar Manoharan (4):
>   ath10k: use local memory instead of shadow descriptor in ce_send
>   ath10k: remove send completion validation in diag read/write
>   ath10k: cleanup copy engine send completion
>   ath10k: remove shadow copy of CE descriptors for source ring

All four applied, thanks.

-- 
Kalle Valo

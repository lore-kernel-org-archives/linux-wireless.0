Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:15789 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbbCENyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 08:54:09 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: Increase copy engine entries for rx wmi
References: <1423460814-2767-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1423460814-2767-2-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 5 Mar 2015 15:53:58 +0200
In-Reply-To: <1423460814-2767-2-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Mon, 9 Feb 2015 11:16:54 +0530")
Message-ID: <87oao74kjt.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_145413_074705_50A1ADD1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Having lower number of copy engine entries for target to host
> WMI ring is causing drops in receiving management frames. This
> issue is observed during max clients (128 clients) stress testing.
> While bursting deauthentication frames from simulated clients,
> approx. 70% of frames are getting dropped due to lower ring entries.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, patch 2 applied.

-- 
Kalle Valo

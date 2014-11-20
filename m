Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:3377 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKTLSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 06:18:03 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix mismatched wmi api call
References: <1415935071-21422-1-git-send-email-poh@qca.qualcomm.com>
Date: Thu, 20 Nov 2014 13:17:56 +0200
In-Reply-To: <1415935071-21422-1-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Thu, 13 Nov 2014 19:17:51 -0800")
Message-ID: <87tx1udst7.fsf@kamboji.qca.qualcomm.com> (sfid-20141120_121807_716754_B0168352)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Fix to use v10.2 wmi call for firmware v10.2.
> It turned out that peer association function was using
> v10.1 wmi call for v10.2 firmware during code review.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied.

(Actually I had applied this already on Nov 17 but forgot to reply.)

-- 
Kalle Valo

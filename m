Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20772 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3I0QqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 12:46:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ath10k: implement FW IE support
References: <20130927131812.20789.9941.stgit@localhost6.localdomain6>
Date: Fri, 27 Sep 2013 19:46:07 +0300
In-Reply-To: <20130927131812.20789.9941.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Fri, 27 Sep 2013 16:20:43 +0300")
Message-ID: <87siwqjjqo.fsf@kamboji.qca.qualcomm.com> (sfid-20130927_184616_520123_0F5CCED8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> FW IE format is needed for ath10k automatically detect what features the
> firmware image supports. This is important especially with 10.x firmwares which
> has a different interface.
>
> Please review.
>
> v2:
>
> * added accidentally dropped board file loading (michal)
>
> * check that ATH10K_FW_IE_FW_IMAGE is available, fail otherwise

Forget this, the changes I made are missing here. I'll send v3.

-- 
Kalle Valo

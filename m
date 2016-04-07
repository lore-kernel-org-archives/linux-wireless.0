Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27823 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbcDGPvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 11:51:51 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH v2 1/3] ath10k: fix calibration init sequence of qca99x0
Date: Thu, 7 Apr 2016 15:51:44 +0000
Message-ID: <87oa9l76y8.fsf@kamboji.qca.qualcomm.com> (sfid-20160407_175156_957161_944540FD)
References: <1460011051-8272-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1460011051-8272-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 7 Apr 2016 12:07:29 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> pre-calibration is meant for qca4019 which contains only caldata
> whereas calibration file is used by ar9888 and qca99x0 that contains
> both board data and caldata. So by definition both pre-cal-file and
> cal-file can not coexist. Keeping them in shared memory (union), is
> breaking boot sequence of qca99x0. Fix it by storing both binaries
> in separate memories. This issue is reported in ipq8064 platform which
> includes caldata in flash memory.
>
> Fixes: 3d9195ea19e4 ("ath10k: incorporate qca4019 cal data download sequence")
> Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

All three applied, thanks. 

-- 
Kalle Valo
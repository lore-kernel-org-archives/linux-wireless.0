Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:60734 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbHMLVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 07:21:49 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vivek Natarajan <nataraja@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k: Support different txbf configuration schemes
References: <1438665312-2768-1-git-send-email-nataraja@qti.qualcomm.com>
Date: Thu, 13 Aug 2015 14:21:38 +0300
In-Reply-To: <1438665312-2768-1-git-send-email-nataraja@qti.qualcomm.com>
	(Vivek Natarajan's message of "Tue, 4 Aug 2015 10:45:11 +0530")
Message-ID: <87a8tvo2m5.fsf@kamboji.qca.qualcomm.com> (sfid-20150813_132152_159608_F75ADF5A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <nataraja@qti.qualcomm.com> writes:

> qca61x4 uses the vdev param as a sole sufficient configuration
> for txbf while qca99x0 enables txbf during peer assoc by
> combining the vdev param value with peer assoc's vht capabilities
>
> This patch gets the appropriate txbf configuration scheme
> before passing the wmi command to enable the same in the firmware.
>
> Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>

Thanks, both patches applied.

-- 
Kalle Valo

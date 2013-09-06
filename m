Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40783 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3IFJwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 05:52:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: set the UART baud rate to 19200
References: <1378211043-20299-1-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 6 Sep 2013 12:52:26 +0300
In-Reply-To: <1378211043-20299-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Tue, 3 Sep 2013 14:24:02 +0200")
Message-ID: <87a9jqi8f9.fsf@kamboji.qca.qualcomm.com> (sfid-20130906_115237_739475_2CE0F9B2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> When configuring the host_interests over BMI, set the UART
> baud rate to 19200. This is valid for QCA988X_2.0 devices.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, both patches applied.

To first patch I added this:

    kvalo: found during code review, there should not be any functionality
    changes

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24789 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3BOLna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 06:43:30 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Ryan Hsu <ryanhsu@qca.qualcomm.com>
Subject: Re: [PATCH 5/6] ath6kl: Fix a debugfs crash for USB devices
References: <1360834689-11187-1-git-send-email-mohammed@qca.qualcomm.com>
	<871uchamyh.fsf@kamboji.qca.qualcomm.com>
	<511E1B7A.60505@qca.qualcomm.com>
Date: Fri, 15 Feb 2013 13:43:20 +0200
In-Reply-To: <511E1B7A.60505@qca.qualcomm.com> (Mohammed Shafi Shajakhan's
	message of "Fri, 15 Feb 2013 16:56:50 +0530")
Message-ID: <87k3q9950n.fsf@kamboji.qca.qualcomm.com> (sfid-20130215_124333_237592_71A79533)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:

>>> +	if (ar->hif_type != ATH6KL_HIF_TYPE_SDIO)
>>> +		return -EINVAL;
>>
>> Actually I think it would be better not to even create the debugfs when
>> using sdio.

Oops, meant of course s/debugfs/debugfs file/. There seems to be packet
loss between my brains and fingers...

> agreed, but looks bit ugly right ? thoughts.

Sorry, but I don't understand how not creating the debugfs file for usb
would be ugly? But this isn't that important, if you want we can do it
like you propose as well.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25635 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3HGIE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 04:04:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: setup peer UAPSD flag correctly
References: <1375853036-2418-1-git-send-email-janusz.dziedzic@tieto.com>
	<87li4e6l67.fsf@kamboji.qca.qualcomm.com>
	<CALhHN=pP32Vw6UMvS93cReWr6WHz3p_3d8mn0FNJtSQGvuGJ9w@mail.gmail.com>
Date: Wed, 7 Aug 2013 11:04:19 +0300
In-Reply-To: <CALhHN=pP32Vw6UMvS93cReWr6WHz3p_3d8mn0FNJtSQGvuGJ9w@mail.gmail.com>
	(Janusz Dziedzic's message of "Wed, 7 Aug 2013 09:42:22 +0200")
Message-ID: <87siym53lo.fsf@kamboji.qca.qualcomm.com> (sfid-20130807_100521_244592_015584D3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Setup UAPSD peer/peer rate flags correctly.
> WMI_RC_UAPSD_FLAG is a peer rate capabilities flag
> and should not be set as a peer flag.
>
> BTW this don't fix any known bug yet, just found during UAPSD check.

OK. If a bug has been during a code review and doesn't fix a known
issue, please mention that in the commit log as well.

I added this also to the wiki.

-- 
Kalle Valo

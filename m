Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17874 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbbCWPZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 11:25:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: enable Adaptive Noise Immunity (ANI) by default
References: <1426763280-11284-1-git-send-email-arnagara@qti.qualcomm.com>
Date: Mon, 23 Mar 2015 17:25:16 +0200
In-Reply-To: <1426763280-11284-1-git-send-email-arnagara@qti.qualcomm.com>
	(Ashok Raj Nagarajan's message of "Thu, 19 Mar 2015 16:37:59 +0530")
Message-ID: <87y4mnd9cz.fsf@kamboji.qca.qualcomm.com> (sfid-20150323_162531_739727_3734105B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> writes:

> ANI helps to improve connectvity and performance in a noisy environment.
> Enabling this feature would help the user experience a better and stable
> wireless connection in a noisy environmnet. This feature is currently not
> enabled for ath10k. Enable this feature by default.
>
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>

Thanks, both patches applied.

-- 
Kalle Valo

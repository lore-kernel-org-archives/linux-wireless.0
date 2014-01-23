Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63484 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaAWL7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 06:59:14 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: add CSA support
References: <1390473506-15677-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 23 Jan 2014 13:59:08 +0200
In-Reply-To: <1390473506-15677-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 23 Jan 2014 11:38:24 +0100")
Message-ID: <87ha8u6h9v.fsf@kamboji.qca.qualcomm.com> (sfid-20140123_125917_834879_4704D28C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This is a refactored and rewritten AP CSA patch
> split into 2. As a bonus this fixes STA CSA as
> well.
>
>
> Michal Kazior (2):
>   ath10k: implement channel switching
>   ath10k: implement AP CSA

Oddly enough only the cover letter was delivered to ath10k list, no idea
what happened to the patches. But I can get the patches from
linux-wireless lists.

But do these patches depend to any mac80211 or cfg80211 patches. Or is
it safe to take these to my ath-next branch?

-- 
Kalle Valo

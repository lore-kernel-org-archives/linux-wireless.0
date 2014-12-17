Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:31743 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaLQKdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:33:09 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: send (re)assoc peer command when NSS changed
References: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
	<1418719980-19753-2-git-send-email-janusz.dziedzic@tieto.com>
Date: Wed, 17 Dec 2014 12:32:45 +0200
In-Reply-To: <1418719980-19753-2-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 16 Dec 2014 09:53:00 +0100")
Message-ID: <87a92mr2gi.fsf@kamboji.qca.qualcomm.com> (sfid-20141217_113312_587222_720384A6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Assoc peer command contain information about NSS.
> When we will get IEEE80211_RC_NSS_CHANGED we should
> also send (re) assoc peer command to be sure firmware
> will know about it and RC will work correctly.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Does this fix a user visible bug or is this something you just found
from doing code review?

-- 
Kalle Valo

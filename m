Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34395 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbcCHIuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 03:50:10 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix size of wireless mode variable
References: <1456419781-14722-1-git-send-email-Larry.Finger@lwfinger.net>
	<87pov6tqcu.fsf@kamboji.qca.qualcomm.com>
	<56DD9472.4050308@lwfinger.net>
Date: Tue, 08 Mar 2016 10:50:02 +0200
In-Reply-To: <56DD9472.4050308@lwfinger.net> (Larry Finger's message of "Mon,
	7 Mar 2016 08:47:14 -0600")
Message-ID: <87io0xs69x.fsf@kamboji.qca.qualcomm.com> (sfid-20160308_095014_582254_02741CBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

>> I can't find commit acc6907b87a9 from any of my trees. And oddly enough
>> I can't either any commits with title "rtlwifi: Fix warning from
>> ieee80211_get_tx_rates() when using 5G". I can fix it before commiting
>> but what should I use?
>>
>> Also the fixes line should not have the word "commit".
>
> Kalle,
>
> I do not know where I got that commit and title. The correct reference
> is commit d76d65fd2695 ("rtlwifi: fix broken VHT support").
>
> If you would rather not fix this on commit, I can submit a new version.

No need, I can edit the commit log before I commit.

-- 
Kalle Valo

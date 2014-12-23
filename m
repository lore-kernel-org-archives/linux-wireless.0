Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16559 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaLWHqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:46:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 8/8] ath10k: ath10k: add support to send delba
References: <1418972099-5296-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1418972099-5296-9-git-send-email-rmanohar@qti.qualcomm.com>
	<1419142431590.38389@qti.qualcomm.com>
Date: Tue, 23 Dec 2014 09:46:28 +0200
In-Reply-To: <1419142431590.38389@qti.qualcomm.com> (Rajkumar Manoharan's
	message of "Sun, 21 Dec 2014 06:13:52 +0000")
Message-ID: <87d27ag65n.fsf@kamboji.qca.qualcomm.com> (sfid-20141223_084758_718845_BA09F1AB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com> writes:

>> Subject: [PATCH 8/8] ath10k: ath10k: add support to send delba
>> 
>> This per-station debugfs entry helps to send delba in manual mode
>> for debugging purpose. It accepts tid, initiator and reason code
>> as inputs.
> Kalle,
>
> Subject needs small correction (ath10k: ath10k:). Do you want
> me send v2 patch for this change?

No need to send v2, I can do the change myself. But I noticed that you
already sent it :)

But in the future please don't resubmit individual patches, that's just
too error prone. Instead just resubmit the whole series.

-- 
Kalle Valo

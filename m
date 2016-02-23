Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17399 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbcBWNXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 08:23:43 -0500
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: "janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k: remove supported chain mask
Date: Tue, 23 Feb 2016 13:23:33 +0000
Message-ID: <1456233812853.59898@qti.qualcomm.com> (sfid-20160223_142346_311369_630F6FA3)
References: <1445948474-16738-1-git-send-email-rmanohar@qti.qualcomm.com>
	<87fv0uq6p7.fsf@kamboji.qca.qualcomm.com>,<CALhHN=orRg2mkjcJ1TGssjEocNrRWEhhDV=SKGYANQ-c+YEyzA@mail.gmail.com>
In-Reply-To: <CALhHN=orRg2mkjcJ1TGssjEocNrRWEhhDV=SKGYANQ-c+YEyzA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> Removing supported chainmask fields as it can be always derived
>>> from num_rf_chains.
>>>
>>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>>
> Hello,
>
> This one break monitor mode for qca988x and 10.x firmware:
> After Revert "ath10k: remove supported chain mask" - works correctly.
> 
Janusz,

Thanks for reporting. Will send out patch asap.

-Rajkumar
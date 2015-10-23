Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62405 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbJWEWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 00:22:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yan Bellavance <ybellavance@tamaggo.com>
CC: "ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>,
	"c_manoha@qca.qualcomm.com" <c_manoha@qca.qualcomm.com>,
	Bartosz Markowski <bartosz.markowski@tieto.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>,
	Marek Puzyniak <marek.puzyniak@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: QCA6174, is it ath6kl or ath10k?
References: <BY2PR15MB0197D5CFB773E0A3F4B6062FA3380@BY2PR15MB0197.namprd15.prod.outlook.com>
	<87wpuf8l94.fsf@kamboji.qca.qualcomm.com>
	<BLUPR15MB01957142BACE26716CCB0841A3270@BLUPR15MB0195.namprd15.prod.outlook.com>
Date: Fri, 23 Oct 2015 07:22:23 +0300
In-Reply-To: <BLUPR15MB01957142BACE26716CCB0841A3270@BLUPR15MB0195.namprd15.prod.outlook.com>
	(Yan Bellavance's message of "Thu, 22 Oct 2015 21:01:06 +0000")
Message-ID: <87pp0643k0.fsf@kamboji.qca.qualcomm.com> (sfid-20151023_062245_093159_729D937B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yan Bellavance <ybellavance@tamaggo.com> writes:

> Thanks for prompt reply.  Frankly, I'm still trying to figure what
> driver we have really.  It's called qcaqcld2.0 but I see references to
> ath6kl in the various folders relating to the wifi. So that is why I
> presumed it was based on a ath6kl driver. What exactly is the
> qcaqcld2.0 driver?

That's the vendor driver. In these lists we don't give any support to
that, we only support upstream drivers like ath10k.

> I know support for ath10k starts with kernel 4.0 and we have kernel
> 3.10 but I don't see anything that would tell me that a backport has
> been applied. And we've been having some issues so that is how I got
> here.

You can always use backports project to get latest ath10k to an older
kernel.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/backports

-- 
Kalle Valo

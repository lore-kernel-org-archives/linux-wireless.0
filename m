Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51340 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbAOHUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 02:20:41 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Sujith Manoharan <sujith@msujith.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
	<CA+BoTQmNkVKyeWB0fCFhG2MfMZYTz6Dp4+cs44Dm4HCKjTc3Zw@mail.gmail.com>
	<21686.15337.153726.847995@gargle.gargle.HOWL>
	<CA+BoTQkX1KFxpyiotADSaFaEea5BrmgvWLTaSRgMbKzHHP=a2Q@mail.gmail.com>
Date: Thu, 15 Jan 2015 09:19:57 +0200
In-Reply-To: <CA+BoTQkX1KFxpyiotADSaFaEea5BrmgvWLTaSRgMbKzHHP=a2Q@mail.gmail.com>
	(Michal Kazior's message of "Wed, 14 Jan 2015 11:12:37 +0100")
Message-ID: <87fvbc1peq.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_082044_983029_E58437BA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> I'm starting to think tasklets are plain evil for network drivers :P

They are. Actually I remember years ago seeing a discussion about
removing tasklets altogether. But obviously it didn't go anywhere as we
still have them.

-- 
Kalle Valo

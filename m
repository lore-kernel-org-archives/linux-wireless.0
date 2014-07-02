Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:42821 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaGBINr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 04:13:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: =?utf-8?Q?Andr=C3=A9?= Valentin <avalentin@marcant.net>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: ath10k OTP loading issues
References: <53AD2EEE.4040704@marcant.net> <53AD4F17.6070604@marcant.net>
Date: Wed, 2 Jul 2014 11:13:38 +0300
In-Reply-To: <53AD4F17.6070604@marcant.net> (=?utf-8?Q?=22Andr=C3=A9?=
 Valentin"'s message of
	"Fri, 27 Jun 2014 13:01:43 +0200")
Message-ID: <87pphop499.fsf@kamboji.qca.qualcomm.com> (sfid-20140702_101353_130989_477A4105)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

André Valentin <avalentin@marcant.net> writes:

> I just saw the old thread about the same point. So I'm trying to look
> in the flash of my router if the OTP is stored there. Does this OTP
> have some kind of magic so I can identify it?

MAC addresses are good one to check. Basically it should be similar data
as in board.bin.

-- 
Kalle Valo

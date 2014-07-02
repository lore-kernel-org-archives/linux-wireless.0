Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58692 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaGBI4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 04:56:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: =?utf-8?Q?Andr=C3=A9?= Valentin <avalentin@marcant.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: ath10k OTP loading issues
References: <53AD2EEE.4040704@marcant.net> <53AD4F17.6070604@marcant.net>
	<87pphop499.fsf@kamboji.qca.qualcomm.com>
	<53B3C3FF.1060207@marcant.net>
Date: Wed, 2 Jul 2014 11:56:09 +0300
In-Reply-To: <53B3C3FF.1060207@marcant.net> (=?utf-8?Q?=22Andr=C3=A9?=
 Valentin"'s message of
	"Wed, 2 Jul 2014 10:34:07 +0200")
Message-ID: <87egy4p2ae.fsf@kamboji.qca.qualcomm.com> (sfid-20140702_105621_045610_B32D1906)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

André Valentin <avalentin@marcant.net> writes:

> Hi!
>
>>> have some kind of magic so I can identify it?
>> 
>> MAC addresses are good one to check. Basically it should be similar data
>> as in board.bin.
>
> Of course I already tried this. But no luck.

How exactly did you search for it? Are you sure you used the correct MAC
address?

> Do you have another idea. Or is the MAC somehow encrypted ?

Nothing special, the MAC address should should be within the first 20
bytes. For example, here's 00:03:07:12:34:56:

$ od -t x1 board.bin  | head -1
0000000 44 08 df 30 02 04 00 03 07 12 34 56 00 00 6a 00

But of course I might be missing something. Or the calibration data is
somehow encrypted on the flash.

-- 
Kalle Valo

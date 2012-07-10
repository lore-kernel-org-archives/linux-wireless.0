Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:63425 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715Ab2GJNGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 09:06:06 -0400
Message-ID: <71781241c331fcbb5687068ddc6bbb06.squirrel@www.infidigm.net> (sfid-20120710_150612_399018_893D2B74)
In-Reply-To: <4FFC08C5.2050606@qca.qualcomm.com>
References: <43a66e0f20b45e9cc461272e83f2c4e4.squirrel@www.infidigm.net>
    <4FFC08C5.2050606@qca.qualcomm.com>
Date: Tue, 10 Jul 2012 09:42:48 -0400
Subject: Re: ar6004 / ar9374
From: drwho@infidigm.net
To: "Kalle Valo" <kvalo@qca.qualcomm.com>
Cc: "Julian Calaby" <julian.calaby@gmail.com>,
	"Sujith Manoharan" <c_manoha@qca.qualcomm.com>,
	"Mohammed Shafi" <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org,
	"ath6kl-devel" <ath6kl-devel@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Also, my UB134 is coming up with a device ID of 0x31c8088a?
>>
>> [  361.676440] ath6kl: Unsupported hardware version: 0x31c8088a
>> [  361.680437] ath6kl: Failed to init ath6kl core: -22
>> [  361.680491] ath6kl_usb: probe of 2-1:1.0 failed with error -22
>> [  361.680520] usbcore: registered new interface driver ath6kl_usb
>
> That's odd, I'm not familiar with 0x31c8088a. I wonder if it's corrupted
> somehow or is it a valid device id? Does anyone from ath6kl-devel know?

Hi Kalle,

We have two units, both come up as 0x31c8088a using your kernel on x86
Ubuntu or using a recent compat-wireless on our arm platform.  The PN on
the chip is

AR9374X-4L3E which is on a usb board

The bubble wrap has the following....
UB134-055
QCABUB134
HT0430121

Jon



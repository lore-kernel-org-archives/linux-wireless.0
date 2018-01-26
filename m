Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.newmedia-net.de ([185.84.6.166]:48208 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbeAZKPD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 05:15:03 -0500
Subject: Re: [PATCH 0/4] ath9k: AR9003 noise floor calibration support
To: Kalle Valo <kvalo@codeaurora.org>,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
 <87o9ll57ps.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <b9553f06-b190-c6ec-bb85-587984abfee0@dd-wrt.com> (sfid-20180126_111507_276459_368E2716)
Date: Fri, 26 Jan 2018 10:59:20 +0100
MIME-Version: 1.0
In-Reply-To: <87o9ll57ps.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i dont know if this is a coincidence. but after testing your patch on a 
standard ubiquiti nanostation m2 the noise floor looks wrong.
it will stay on -112 which is clearly impossible in 2.4 (before it was 
around -96)

Sebastian

Am 23.01.2018 um 08:56 schrieb Kalle Valo:
> Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:
>
>> AR9003 series allows to calibrate noise floor for different frequency
>> bins. Once it's done it's possible to get more accurate rssi/signal
>> values over whole frequency band at a given temperature.
>> The RSSI/signal accuracy reported by calibrated RF cards improves
>> from 6 to up to 2dB.
>>
>> This could be interesting for application which require good signal
>> accuracy like roaming or mesh protocols.
> This is a very good description of the feature. I think you should copy
> it to the patch 3 commit log so that it gets archived to git. (I don't
> store cover letters to git.)
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

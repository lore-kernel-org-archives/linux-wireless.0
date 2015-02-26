Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:40354 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbbBZQGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 11:06:54 -0500
Received: by mail-ob0-f175.google.com with SMTP id va2so11920802obc.6
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 08:06:54 -0800 (PST)
Message-ID: <54EF449C.5090604@lwfinger.net> (sfid-20150226_170657_903537_DA9D3AD8)
Date: Thu, 26 Feb 2015 10:06:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] ssb: Silence warning for unknown backplane revision
References: <1424290178-25328-1-git-send-email-Larry.Finger@lwfinger.net> <87vbiode4s.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87vbiode4s.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2015 06:57 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> When using a BCM4318 in a PCMCIA format, I get a startup message that the
>> device uses backplane revision 0xF000000. Next a WARNING is logged. Despite
>> the message, the device works fine, This patch silences the warning.
>>
>> Cc: Rafał Miłecki <zajec5@gmail.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Should this go to 4.0?

As this one merely stops log spamming, sending it through NEXT is OK.

Larry



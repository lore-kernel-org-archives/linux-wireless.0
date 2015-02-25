Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:28201 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbbBYTye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 14:54:34 -0500
Message-ID: <54EE2877.2040906@broadcom.com> (sfid-20150225_205437_422173_244C8C49)
Date: Wed, 25 Feb 2015 20:54:31 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jocky Wilson <jockyw2001@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac43241b4-sdio / Thinkpad Tablet 10 issues
References: <54E2E1CD.5020203@m-labs.hk> <54E31CD5.70901@broadcom.com> <54E778F9.1000500@m-labs.hk> <loom.20150225T131550-21@post.gmane.org>
In-Reply-To: <loom.20150225T131550-21@post.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/15 13:23, Jocky Wilson wrote:
> Sebastien Bourdeauducq<sb@...>  writes:
>
>>
>> On Tuesday, February 17, 2015 03:49 AM, Arend van Spriel wrote:
>>> So it is a one-off and not showing the issue you are seeing. Your issue
>>> seems to be due to failing firmware so you may need b5 firmware.
>>
>> Making some progress :)
>> ...
>> I guess that the driver has bugs with decoding some of the data sent by
>> the card.
>>
> I can confirm this with my Thinkpad Tablet 8
> which has same chip revision.
> Arend: do you need anything else to be tested?

Nope. As it turns out this chip revision indeed needs b5 firmware. As 
windows and linux use different firmware we will need to release that to 
linux-firmware and modify brcmfmac to pick it up properly. Keep an eye 
out for those patches.

Regards,
Arend

> /JockyW
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


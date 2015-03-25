Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0072.outbound.protection.outlook.com ([157.56.112.72]:20825
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751876AbbCYBAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 21:00:33 -0400
From: Stefano Cappa <stefano.cappa@mail.polimi.it>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: informations about Linux wifi driver's architecture today
Date: Wed, 25 Mar 2015 01:00:30 +0000
Message-ID: <1427245230396.59674@mail.polimi.it> (sfid-20150325_020037_214635_A2DA5B31)
References: <1427048376242.67051@mail.polimi.it>,<CAMowtuMgAPsgAKuwSibjAzhDbqEdZGatikCiKks6f3w=4oth+Q@mail.gmail.com>
 <1427059313289.43792@mail.polimi.it>,<550FE50F.10303@broadcom.com>
In-Reply-To: <550FE50F.10303@broadcom.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much Arend, in particular for the documentation.

If i understand correctly, the levels are:
userspace
nl802111
cfg80211
firmware

No mac80211 because is a fullmac.
Correct?

Thank u, Stefano.

________________________________________
Da: Arend van Spriel <arend@broadcom.com>
Inviato: lunedì 23 marzo 2015 11.03
A: Stefano Cappa
Cc: linux-wireless@vger.kernel.org
Oggetto: Re: informations about Linux wifi driver's architecture today

On 03/22/15 22:21, Stefano Cappa wrote:
> Hi
> I prefer a generic version, without specific things, like this one: h**p://postimg.org/image/hfkpjt3ux/ created by Johannes Berg.
>
> And, if available something for the broadcom chip bcm4339.

Hi Stefano,

The bcm4339 is supported by the brcmfmac driver and is a cfg8211-based
driver aka fullmac device where the 802.11 stack runs on the device. I
did write up some stuff about the driver internally, but we can consider
putting it on wireless.kernel.org under creative commons license.

Regards,
Arend

> Thank you.
>
> ________________________________________
> Da: Kathy Giori<kathy.giori@gmail.com>
> Inviato: domenica 22 marzo 2015 19.35
> A: Stefano Cappa
> Cc: linux-wireless@vger.kernel.org
> Oggetto: Re: informations about Linux wifi driver's architecture today
>
> On Sun, Mar 22, 2015 at 11:19 AM, Stefano Cappa
> <stefano.cappa@mail.polimi.it>  wrote:
>> Hi!
>> some months ago, i saw the presentation of Johannes Berg in PDF, but now it isn't available, probably because it's very old.
>>
>> This slides will be updated to a new release?
>>
>> I have this slide and in page 5/35 (2009-02-26) there is the "Architecture - planned". This is the actual architecture or there are some differences in 2015? If yes, where i can find the new version of this page, with a little diagram?
>
> Ciao Stefano,
>
> Perhaps Johannes can post a current overview diagram on the Linux
> wireless wiki (if you share with him which diagram you want to be
> updated).
>
> In terms of vendor-specific architecture, and how it fits in, Kalle
> Valo posted a high-level diagram for ath10k:
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/architecture
>
> Are you mainly interested in the architecture of vendor-agnostic upper
> layers or a description of a specific vendor driver?
> kg--
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


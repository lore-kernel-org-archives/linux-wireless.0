Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tpesmarthost.raritan.com ([220.128.57.202]:37481 "EHLO
	tpesmarthost.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaKFNuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 08:50:50 -0500
Message-ID: <545B7CB2.4080507@raritan.com> (sfid-20141106_145055_984268_8A283FD1)
Date: Thu, 6 Nov 2014 14:50:42 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	<linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] mac80211: Fix regression that triggers a kernel BUG with
 CCMP
References: <1415267752-4704-1-git-send-email-ronald.wahl@raritan.com>		 <1415268135.1884.1.camel@sipsolutions.net> <545B6AD3.8020301@broadcom.com>	 <1415277562.17015.4.camel@sipsolutions.net> <545B7290.6060409@raritan.com> <1415279690.17015.7.camel@sipsolutions.net>
In-Reply-To: <1415279690.17015.7.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06.11.2014 14:14, Johannes Berg wrote:
> On Thu, 2014-11-06 at 14:07 +0100, Ronald Wahl wrote:
>
>> But there are LTS kernels not maintained by Greg like 3.12 and 3.16. How
>> about these? If sending patches to stable@kernel org is optional then
>> it's better to kill that list or silently drop emails send to this list
>> so no errors are returned for this address.
>
> They can pick it up the same way though, no? Actually I think they
> usually pick it up from Greg's tree anyway :)

"Can" and "do" are different things. And you "think" you know what 
others people do but do you really "know" it? Anyway your original 
comment sounded a bit like "avoid sending it to the stable kernel 
mailinglist otherwise unwanted things might happen". In the end this 
raises the question why that stable kernel mailing still list exists or 
why there is no general rule not to send mails to it.

So in the end that currently means that it is not wrong to send mail to 
stable@vger.kernel.org but it is your opinion that it is just not really 
necessary, right?

- ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Ralf Ploenes

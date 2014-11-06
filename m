Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tpesmarthost.raritan.com ([220.128.57.202]:13088 "EHLO
	tpesmarthost.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKFNHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 08:07:39 -0500
Message-ID: <545B7290.6060409@raritan.com> (sfid-20141106_140743_028279_27013AB2)
Date: Thu, 6 Nov 2014 14:07:28 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>
CC: <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] mac80211: Fix regression that triggers a kernel BUG with
 CCMP
References: <1415267752-4704-1-git-send-email-ronald.wahl@raritan.com>	 <1415268135.1884.1.camel@sipsolutions.net> <545B6AD3.8020301@broadcom.com> <1415277562.17015.4.camel@sipsolutions.net>
In-Reply-To: <1415277562.17015.4.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06.11.2014 13:39, Johannes Berg wrote:
> On Thu, 2014-11-06 at 13:34 +0100, Arend van Spriel wrote:
>> On 06-11-14 11:02, Johannes Berg wrote:
>>> Oh, regarding Cc stable - don't actually send the mail there if you can
>>> help it.
>>
>> What do you mean? Are you saying: It must be tagged, but 'git
>> send-email' should not actually add the Cc field in the mail header.
>> What is the story here? Guess I missed a memo ;-)
>
> As far as I remember Greg just ignores the patches sent to the list and
> picks them up when they hit Linus's tree instead (i.e. follows the
> commit logs with like 'git log --grep "Cc: stable"') so there's no value
> in actually sending out email, it's just noise.
>
> So far it has worked for me, so I think it must be right :)

But there are LTS kernels not maintained by Greg like 3.12 and 3.16. How 
about these? If sending patches to stable@kernel org is optional then 
it's better to kill that list or silently drop emails send to this list 
so no errors are returned for this address.

- ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Ralf Ploenes

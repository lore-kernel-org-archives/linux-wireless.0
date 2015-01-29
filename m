Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:33572 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbA2TXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 14:23:16 -0500
Message-ID: <54CA88A1.4020107@broadcom.com> (sfid-20150129_202319_639337_2CAFF42C)
Date: Thu, 29 Jan 2015 20:23:13 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: moving the wiki
References: <1392060043.4128.37.camel@jlt4.sipsolutions.net>	 (sfid-20140210_202050_594107_FC8E5876) <1422543484.6322.10.camel@sipsolutions.net>
In-Reply-To: <1422543484.6322.10.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/15 15:58, Johannes Berg wrote:
> It's almost been a year, but this finally happened...
>
> The new wiki is at https://wireless.wiki.kernel.org/ but the old URL
> (http://wireless.kernel.org/) will continue to work and redirect to the
> new one. Note that right now you need a Linux Foundation identity to be
> able to edit.

I tried to edit the table of drivers and noticed that page is somewhat 
garbled at the end. Anyway, for some drivers it lists phy mode as 
"A(1)/B/G/N". Now the (1) probably is meant to refer to some footnote 
but it is gone. Maybe deliberate (see below)?
>
>>   * I'll keep the read-only wiki at http://wireless.sipsolutions.net/ for
>> a while, in case somebody needs history - you can also download page/history
>> snapshots.
>
> It's actually at http://linuxwireless.sipsolutions.net/ and is just a
> static dump of the old wiki contents. Please don't copy content I
> removed from the new wiki to the old one - we didn't get permission for
> that content to be licensed under the new wiki's license.

I guess this needs to be corrected: "Please don't copy content from the 
old wiki to the new wiki. It has been removed deliberately as we didn't 
get permission for that content to be licensed under the new wiki's 
license".

Regards,
Arend

>> experience skinning mediawiki
>
> It's actually dokuwiki now, so if anyone wants to restore the old site's
> template/layout a dokuwiki template will be needed.
>
>> Obviously, another consequence is that the wiki markup will change
>> somewhat. Moin and Mediawiki aren't too far from each other (except for
>> table syntax), but there are some things that are different that you'll
>> have to get used to when editing.
>
> Again, dokuwiki - slightly different from moinmoin.
>
>> I think/hope that all this can happen over the next few days. If there
>> are any concerns (other than "don't do it") let me know.
>
> Yeah, well, "days" :-)
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


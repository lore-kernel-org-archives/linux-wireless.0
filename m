Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53298 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab3H1OaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 10:30:10 -0400
Message-ID: <521E096C.5050501@candelatech.com> (sfid-20130828_163017_705249_26A54B42)
Date: Wed, 28 Aug 2013 07:30:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw:  Print Interworking IE details in scan results.
References: <1377619631-14699-1-git-send-email-greearb@candelatech.com>  (sfid-20130827_180728_764261_AD0BAEF5) <1377678223.13797.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1377678223.13797.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/28/2013 01:23 AM, Johannes Berg wrote:
> On Tue, 2013-08-27 at 09:07 -0700, greearb@candelatech.com wrote:
>
>> 	802.11u Interworking:
>> 		Network Options: 0xf1
>> 			Network Type: 1 (Private with Guest)
>> 			Internet
>> 			ASRA
>> 			ESR
>> 			UESA
>> 		Venu Group: 2 (Business)
>> 		Venu Type: 1
>
> That should be "Venue", no?

Yes, I kept typo-ing that..I think I fixed up the code in the patch, but
will double-check.

>
>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> No need really, btw, this doesn't mean anything in the iw repository - I
> haven't bothered to add something (yet).
>
>> +++ b/scan.c
>> @@ -614,6 +614,69 @@ static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
>>   	print_ht_mcs(data + 3);
>>   }
>>
>> +static const char* ntype_11u(uint8_t t) {
>
> I'd prefer kernel style with the opening brace on the next line :)

I'll fix that and re-submit the series.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


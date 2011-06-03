Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1501 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1FCQhr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 12:37:47 -0400
Message-ID: <4DE90DCE.6060207@broadcom.com> (sfid-20110603_183751_979598_E5B3920A)
Date: Fri, 3 Jun 2011 18:37:34 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t
 with struct si_pub
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-44-git-send-email-rvossen@broadcom.com>
 <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
In-Reply-To: <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Julian,

the structure definition itself is already in a header file (aiutils.h). 
Probably you are referring to the forward declaration used in the patch?

Bye, Roland.

On 06/02/2011 01:58 AM, Julian Calaby wrote:
> On Wed, Jun 1, 2011 at 21:45, Roland Vossen<rvossen@broadcom.com>  wrote:
>> Code cleanup.
>>
>> Signed-off-by: Roland Vossen<rvossen@broadcom.com>
>> Reviewed-by: Arend van Spriel<arend@broadcom.com>
>>
>> diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
>> index 2cc9bc7..9819a35 100644
>> --- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
>> +++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
>> @@ -27,7 +27,8 @@
>>   #include<dngl_stats.h>
>>   #include<dhd.h>
>>   #include<linux/ieee80211.h>
>> -typedef const struct si_pub si_t;
>> +
>> +struct si_pub;
>>
>>   #include<dngl_stats.h>
>>   #include<dhd.h>
>
> Should this struct definition be in a header file somewhere?



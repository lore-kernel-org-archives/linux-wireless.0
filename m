Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:12501
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751515AbdF1UYT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:24:19 -0400
Subject: Re: [PATCH] ieee80211: update public action codes
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1498601249-8372-1-git-send-email-peter.oh@bowerswilkins.com>
 <d9aaa85b-49ac-494e-7979-afc42d309dc4@broadcom.com>
Cc: johannes.berg@intel.com
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <ccd3208a-8235-ffbc-79cd-422115f5f3ab@bowerswilkins.com> (sfid-20170628_222425_338464_4AD4A57C)
Date: Wed, 28 Jun 2017 13:24:06 -0700
MIME-Version: 1.0
In-Reply-To: <d9aaa85b-49ac-494e-7979-afc42d309dc4@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/28/2017 01:16 PM, Arend van Spriel wrote:
> On 28-06-17 00:07, peter.oh@bowerswilkins.com wrote:
>> From: Peter Oh <peter.oh@bowerswilkins.com>
>>
>> Update Public Action field values as updated in IEEE Std 802.11-2016,
>> so that modules/drivers can refer it.
> Hi Peter,
>
> I am pretty sure there are a lot of other definitions in the 802.11 spec
> that are not in a linux header file. So are you planning on submitting
> driver patches using the added definitions. Stuff is mostly added as needed.
I have extra patches that uses the new values, but doubt if it's fit to 
be upstream.
> Regards,
> Arend

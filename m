Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3267 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab2JKJJi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 05:09:38 -0400
Message-ID: <50768CC6.5050007@broadcom.com> (sfid-20121011_110944_110026_5A15D517)
Date: Thu, 11 Oct 2012 11:09:26 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>
cc: "Julian Calaby" <julian.calaby@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v0 0/2] driver for 60g Wilocity chip wil6210
References: <1349893385-23102-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <CAGRGNgUidXkunAuXXoM54-d48HcnAvYBiHrmZL5_7jt=ytF5AQ@mail.gmail.com>
 <3023056.XLicri5zy7@lx-vladimir>
In-Reply-To: <3023056.XLicri5zy7@lx-vladimir>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2012 08:35 AM, Vladimir Kondratiev wrote:
> On Thursday, October 11, 2012 09:51:28 AM Julian Calaby wrote:
>> Hi Vladimir,
>>
>> On Thu, Oct 11, 2012 at 5:23 AM, Vladimir Kondratiev
>>
>> <qca_vkondrat@qca.qualcomm.com> wrote:
>>> Hi,
>>>
>>> Here goes driver for the "wil6210" chip by Wilocity.
>>>
>>
>> Whilst I'm sure that this driver will end up being kernel quality
>> code, as this is an initial development snapshot, have you considered
>> putting it in "staging" until it's mostly feature complete?
>>
>
> Hi,
>
> Sure I asked this very question before submitting. Luis advised to go for
> the regular location, not "staging". I am pretty neutral about what location
> is better, so I just follow recommendations on this matter.
>
> Thanks, Vladimir.

 From my own experiences I got the impression that the staging directory 
was more about learning the development process and converting a 
proprietary driver with all kind of abstractions for multi-OS support to 
a native linux driver. So I would agree with Luis, but you could have 
used RFC instead of PATCH to draw more attention to this although the 
'60g' term will trigger that as well.

Regards,
AvS



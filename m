Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43133 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbbJQOt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 10:49:28 -0400
Message-ID: <56225FF6.3080806@candelatech.com> (sfid-20151017_164956_640651_8F95E96A)
Date: Sat, 17 Oct 2015 07:49:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ramprasad Vempati <ramprasad.vempati@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: How to enforce Wireless Mode of Station?
References: <CAB6w8enLcU8LZfL=Uzpi5x6od_VExUdTW2PT9norQ=8POGNFcw@mail.gmail.com> <CAB6w8ekg-6-p=ar=crbfDetHPG1bEsszgOKMAwVi2DTs5UL2rg@mail.gmail.com>
In-Reply-To: <CAB6w8ekg-6-p=ar=crbfDetHPG1bEsszgOKMAwVi2DTs5UL2rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You need patches to wpa_supplicant and the kernel to make this
really work correctly.  Those patches are not upstream at this
point.

Thanks,
Ben


On 10/17/2015 02:59 AM, Ramprasad Vempati wrote:
> Hi,
>
> Can someone clarify?
>
> Thanks,
> Ram
>
> On Thu, Oct 8, 2015 at 12:20 AM, Ramprasad Vempati
> <ramprasad.vempati@gmail.com> wrote:
>> Hi,
>>
>> I've been trying to find how to control wireless mode, i.e. 802.11b or
>> 802.11g or 802.11ng or 802.11a etc for Station mode. In general for
>> Station mode, the connection happens with AP based AP mode. But for
>> test purpose, if I would like to control mode of a wireless station,
>> is it possible?  I mean when AP is 11bgn mode, if I want STA to
>> associate in 11b mode?
>>
>> I understand "iw" can be used to set rate mask. But I've tried with
>> ath9k or intel chipsets. I've not been able to get it working as most
>> of the vendors didn't implement this.
>>
>> Is there a different way to enforce specific wireless mode on station?
>>
>> Thanks,
>> Ram
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

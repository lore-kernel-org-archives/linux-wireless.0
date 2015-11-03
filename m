Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59102 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbKCI4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 03:56:49 -0500
Message-ID: <56387786.8070608@atmel.com> (sfid-20151103_095652_862350_AC6A31C0)
Date: Tue, 3 Nov 2015 17:59:50 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Shivani Bhardwaj <shivanib134@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, <tony.cho@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: Re: About the patch "Staging: wilc1000: coreconfigurator: Drop unneeded
 wrapper functions"
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>	<1446174642-28570-17-git-send-email-glen.lee@atmel.com>	<5636BFA6.5070500@atmel.com> <CAKHNQQF+DEZmv83Lo=S4qAd85ffdPgftCuZ-nbGPCSKFAAXhBA@mail.gmail.com>
In-Reply-To: <CAKHNQQF+DEZmv83Lo=S4qAd85ffdPgftCuZ-nbGPCSKFAAXhBA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shivani,

I will revert as you said, I always appreciate all the effort and your time to help.

Regards,
glen lee.


On 2015년 11월 03일 17:26, Shivani Bhardwaj wrote:
> On Mon, Nov 2, 2015 at 7:13 AM, glen lee <glen.lee@atmel.com> wrote:
>> Hi Shivani Bhardwaj,
>>
>> Thank you for the patches.
>>
>> I am writing this new mail thread since I didn't received about following
>> patch which is applied recently.
>>
>> https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/patch/drivers/staging/wilc1000?id=d4622f68db8095dd54179e3134e97812727f6b89
>>
>> I have tested this on hardware but it did not working.
>> As far as I know, ether_addr_copy function can be used when src and dst
>> addresss are __aligned(2) and it has to be proved.
>> Would you let us know the addresses are properly aligned? I cannot make sure
>> the data is aligned(2).
> Hi Glen,
>
> Thanks for pointing out. I checked it. The alignment is wrong. Please
> drop this patch. I'm really sorry for the inconvenience caused. I'll
> make sure to send a new patch with correct alignment.
>
> Thank you
> Shivani
>
>> Regards,
>> glen lee.
>>


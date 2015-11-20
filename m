Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:51142 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934750AbbKTB06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 20:26:58 -0500
Message-ID: <564E77A9.2020200@atmel.com> (sfid-20151120_022723_154040_CC4CBD2A)
Date: Fri, 20 Nov 2015 10:30:17 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	<devel@driverdev.osuosl.org>, <austin.shin@atmel.com>,
	<linux-wireless@vger.kernel.org>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <tony.cho@atmel.com>,
	<leo.kim@atmel.com>, <adham.abozaeid@atmel.com>
Subject: Re: [PATCH 3/4] staging: wilc1000: rename index to tcp_pending_ack_idx
References: <1447898761-6938-1-git-send-email-glen.lee@atmel.com> <1447898761-6938-3-git-send-email-glen.lee@atmel.com> <20151119062343.GR18797@mwanda> <564D71EE.20704@atmel.com> <20151119154551.GB7601@kroah.com>
In-Reply-To: <20151119154551.GB7601@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 11월 20일 00:45, Greg KH wrote:
> On Thu, Nov 19, 2015 at 03:53:34PM +0900, glen lee wrote:
>>
>> On 2015년 11월 19일 15:23, Dan Carpenter wrote:
>>> On Thu, Nov 19, 2015 at 11:06:00AM +0900, Glen Lee wrote:
>>>> This patch renames "index" of struct txq_entry_t to tcp_pending_ack_idx since
>>>> this name could be confused index of txq_entry_t. It is index of tcp pending
>>>> ack.
>>>>
>>>> It fixes 8e55639d066f4ef402ba88fca08ed1be70e1c4da
>>>>
>>> It is just a cleanup patch and not a bugfix patch so "fix" is the wrong
>>> word here.  But the correct format for fixes tags is:
>>>
>>> Fixes: 123456789012 ('Title of patch')
>> I see, I learned another one. Thanks.
> Git can do this automatically for you:
> 	 git show -s --abbrev-commit --abbrev=12 --pretty=format:"%h (\"%s\")%n"

This is helpful for me. Thanks.

regards,
glen lee

> I have an alias for this to make it easier to use frequently.
>
> greg k-h


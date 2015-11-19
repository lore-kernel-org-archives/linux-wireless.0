Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58309 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872AbbKSGuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:50:16 -0500
Message-ID: <564D71EE.20704@atmel.com> (sfid-20151119_075025_375925_F555727A)
Date: Thu, 19 Nov 2015 15:53:34 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<Nicolas.FERRE@atmel.com>, <adel.noureldin@atmel.com>,
	<tony.cho@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
Subject: Re: [PATCH 3/4] staging: wilc1000: rename index to tcp_pending_ack_idx
References: <1447898761-6938-1-git-send-email-glen.lee@atmel.com> <1447898761-6938-3-git-send-email-glen.lee@atmel.com> <20151119062343.GR18797@mwanda>
In-Reply-To: <20151119062343.GR18797@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 11월 19일 15:23, Dan Carpenter wrote:
> On Thu, Nov 19, 2015 at 11:06:00AM +0900, Glen Lee wrote:
>> This patch renames "index" of struct txq_entry_t to tcp_pending_ack_idx since
>> this name could be confused index of txq_entry_t. It is index of tcp pending
>> ack.
>>
>> It fixes 8e55639d066f4ef402ba88fca08ed1be70e1c4da
>>
> It is just a cleanup patch and not a bugfix patch so "fix" is the wrong
> word here.  But the correct format for fixes tags is:
>
> Fixes: 123456789012 ('Title of patch')

I see, I learned another one. Thanks.

>
> regards,
> dan carpenter
>


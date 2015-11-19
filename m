Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:18819 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbKSGaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:30:35 -0500
Message-ID: <564D6D51.1010006@atmel.com> (sfid-20151119_073039_562333_CB0B1625)
Date: Thu, 19 Nov 2015 15:33:53 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<Nicolas.FERRE@atmel.com>, <adel.noureldin@atmel.com>,
	<tony.cho@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
Subject: Re: [PATCH 1/4] staging: wilc1000: remove define COMPLEMENT_BOOT
References: <1447898761-6938-1-git-send-email-glen.lee@atmel.com> <20151119061907.GQ18797@mwanda>
In-Reply-To: <20151119061907.GQ18797@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2015년 11월 19일 15:19, Dan Carpenter wrote:
> On Thu, Nov 19, 2015 at 11:05:58AM +0900, Glen Lee wrote:
>> This patch removes define COMPLEMENT_BOOT in Makefile. The feature was removed
>> by the following commit but the define was not removed. So remove completely.
>>
>> b46d68825c2d3af70ad18b53dfed6516e393b7fa
> Put some human readable text next to the hash.  The standard thing is to
> include only the first 12 characters of the hash.  If there are fewer
> than 12 characters then we could get collisions but including the whole
> hash is excessive.

Ok, I understand. Thank you for your advise.

regards,
glen lee

>
> This patch removes define COMPLEMENT_BOOT in Makefile. The feature was
> removed by commit b46d68825c2d ('staging: wilc1000: remove
> COMPLEMENT_BOOT') but the define was not removed. So remove completely.
>
> regards,
> dan carpenter
>


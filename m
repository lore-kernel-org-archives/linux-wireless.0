Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:42511 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbbIUGDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 02:03:47 -0400
Subject: Re: [PATCH v2 02/34] staging: wilc1000: remove typedef from the
 struct
To: Greg KH <gregkh@linuxfoundation.org>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
 <1442805423-3711-3-git-send-email-tony.cho@atmel.com>
 <20150921055425.GA2514@kroah.com>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <55FF9DB3.8040403@atmel.com> (sfid-20150921_080350_554578_E6197144)
Date: Mon, 21 Sep 2015 15:03:31 +0900
MIME-Version: 1.0
In-Reply-To: <20150921055425.GA2514@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 09월 21일 14:54, Greg KH wrote:
> On Mon, Sep 21, 2015 at 12:16:31PM +0900, Tony Cho wrote:
>> The Linux kernel coding style does not recommend to use typedef for the
>> structure. This patch removes typedef from the host_if_msg structure.
>>
>> Signed-off-by: Tony Cho <tony.cho@atmel.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> This too is already in my tree, you don't have to resend it.

Understood, sorry for your inconvenience.

Thanks,

Tony.



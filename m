Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16663 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbbIOGuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 02:50:04 -0400
Subject: Re: [PATCH 0/7] remove wilc_errorsupport.h from the wilc driver
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
References: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
 <20150915062715.GG12611@sudip-pc>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<rachel.kim@atmel.com>, <chris.park@atmel.com>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <55F7BF9A.6070600@atmel.com> (sfid-20150915_085009_578568_38E58759)
Date: Tue, 15 Sep 2015 15:50:02 +0900
MIME-Version: 1.0
In-Reply-To: <20150915062715.GG12611@sudip-pc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 09월 15일 15:27, Sudip Mukherjee wrote:
> On Tue, Sep 15, 2015 at 11:53:34AM +0900, Tony Cho wrote:
>> This patch aims to remove the wilc_errorsupport.h which is unnecessary in the
>> wilc driver. This patch replaces the error types defined by wilc driver with
>> kernel generic error types and removes macros which handles the errors.
> Patch 2/7 and 4/7 are introducing new checkpatch warnings which again
> some has to fix in a separate patch. Better to fix it while you are
> sending. And instead of printk it should be pr_err or much better if you
> can use netev_err. Looks like it can be used in some of the functions.
>
> regards
> sudip

I will check patch warnings and resend v2. I'm designing new debug functions and it will be
introduced in the next patch.

Thanks for your advice,
Tony.



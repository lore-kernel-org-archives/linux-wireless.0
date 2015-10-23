Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:14489 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbbJWHgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 03:36:25 -0400
Subject: Re: [PATCH 05/28] staging: wilc1000: wilc_handle_isr: add argument
 wilc to wilc_handle_isr
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Glen Lee <glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
 <1445578124-31486-5-git-send-email-glen.lee@atmel.com>
 <20151023065703.GV7340@mwanda>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<Nicolas.FERRE@atmel.com>, <adel.noureldin@atmel.com>,
	<leo.kim@atmel.com>, <adham.abozaeid@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <5629E367.1000006@atmel.com> (sfid-20151023_093653_054554_49C93687)
Date: Fri, 23 Oct 2015 16:36:07 +0900
MIME-Version: 1.0
In-Reply-To: <20151023065703.GV7340@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 23일 15:57, Dan Carpenter wrote:
> On Fri, Oct 23, 2015 at 02:28:21PM +0900, Glen Lee wrote:
>> This patch add new argument wilc to wilc_handle_isr and pass wilc to
>> the function.
> It's not important enough to redo the patch but why are we sometimes
> using "wl" and sometimes "wilc"?

We have wl_xxx_xxx as naming conventions for the function prefix to represent that
they are owned in the wireless link controller because the driver will support
other line-ups as well as wilc1000, so we will remove wilc1000 prefix and
are changing them. In addition, the function parameter names will be wilc
for the variable of struct wilc.

The "wl" is local variable naming as well.
Do you point out "struct wilc *wilc" in the structure wilc_sdio?

Thanks for your review always.
Tony.

> regards,
> dan carpenter
>


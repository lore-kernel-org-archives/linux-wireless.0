Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:33409 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbcFDAty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 20:49:54 -0400
Subject: Re: [PATCH] b43: Remove unused phy_a code
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
References: <1464989566-1393-1-git-send-email-linux@roeck-us.net>
 <20160603233519.4606b1ef@wiggum>
Cc: Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <575225B8.2040607@roeck-us.net> (sfid-20160604_025021_637103_CBAF61AC)
Date: Fri, 3 Jun 2016 17:50:00 -0700
MIME-Version: 1.0
In-Reply-To: <20160603233519.4606b1ef@wiggum>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2016 02:35 PM, Michael Büsch wrote:
> On Fri,  3 Jun 2016 14:32:46 -0700
> Guenter Roeck <linux@roeck-us.net> wrote:
>
>> gcc-6 reports the following error with -Werror=unused-const-variable.
>>
>> drivers/net/wireless/broadcom/b43/phy_a.c:576:40: error:
>> 	'b43_phyops_a' defined but not used
>>
>> Turns out a lot of code in this file is unused, so let's remove it.
>
>
> All a-phy code is usused.
> So you can basically remove the whole file and any other A-PHY code.

I love removing code. I'll resend with more code removed.

Guenter


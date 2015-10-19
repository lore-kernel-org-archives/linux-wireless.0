Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:32111 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbJSCTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 22:19:54 -0400
Subject: Re: [PATCH 03/16] staging: wilc1000: rename g_linux_wlan to wl
To: Greg KH <gregkh@linuxfoundation.org>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
 <1444823204-16736-3-git-send-email-tony.cho@atmel.com>
 <20151017043349.GA23351@kroah.com>
CC: <devel@driverdev.osuosl.org>, <rachel.kim@atmel.com>,
	<chris.park@atmel.com>, <austin.shin@atmel.com>,
	<linux-wireless@vger.kernel.org>, <johnny.kim@atmel.com>,
	<Nicolas.FERRE@atmel.com>, <adel.noureldin@atmel.com>,
	<leo.kim@atmel.com>, <adham.abozaeid@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <56245338.9010707@atmel.com> (sfid-20151019_041957_305671_9AC71467)
Date: Mon, 19 Oct 2015 11:19:36 +0900
MIME-Version: 1.0
In-Reply-To: <20151017043349.GA23351@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 17일 13:33, Greg KH wrote:
> On Wed, Oct 14, 2015 at 08:46:31PM +0900, Tony Cho wrote:
>> This patch renames g_linux_wlan to wl.
> Why?  What's wrong with g_linux_wlan?  You will need to delete this
> entire variable soon anyway, might as well leave it alone until then.

The reason why I rename it to the "wl" is that there first is 80 ending line over issue due to its length where I want to modify
and also we will take our representative structure as "wl" in the future. As you expected, finally g_linux_wlan global variable will
all be deleted by referring it from the private structure as it is introduced in another 13 series of patch.

However, as you guided, I will leave it until all of patch is done.

Thanks,

Tony.

> thanks,
>
> greg k-h


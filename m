Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14340 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbKBBkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2015 20:40:04 -0500
Message-ID: <5636BFA6.5070500@atmel.com> (sfid-20151102_024038_145027_E97E0112)
Date: Mon, 2 Nov 2015 10:43:02 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <shivanib134@gmail.com>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: About the patch "Staging: wilc1000: coreconfigurator: Drop unneeded
 wrapper functions"
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com> <1446174642-28570-17-git-send-email-glen.lee@atmel.com>
In-Reply-To: <1446174642-28570-17-git-send-email-glen.lee@atmel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shivani Bhardwaj,

Thank you for the patches.

I am writing this new mail thread since I didn't received about following patch which is applied recently.

https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/patch/drivers/staging/wilc1000?id=d4622f68db8095dd54179e3134e97812727f6b89

I have tested this on hardware but it did not working.
As far as I know, ether_addr_copy function can be used when src and dst addresss are __aligned(2) and it has to be proved.
Would you let us know the addresses are properly aligned? I cannot make sure the data is aligned(2).

Regards,
glen lee.


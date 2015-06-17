Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0138.outbound.protection.outlook.com ([157.56.112.138]:20544
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751037AbbFQEmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 00:42:45 -0400
From: "Abdul, Hussain (H.)" <habdul@visteon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>
Subject: Re: [PATCH] Staging: wilc1000: Remove casting the values returned by
 kmalloc()
Date: Wed, 17 Jun 2015 04:42:42 +0000
Message-ID: <DB5PR06MB1112C020EAEC66E0AB8E298ADFA60@DB5PR06MB1112.eurprd06.prod.outlook.com> (sfid-20150617_064254_240476_E5C00606)
References: <1434438514-5247-1-git-send-email-habdul@visteon.com>
 <20150617021843.GA18383@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 17 June 2015 07:48 AM, gregkh@linuxfoundation.org wrote:
> On Tue, Jun 16, 2015 at 07:09:56AM +0000, Abdul, Hussain (H.) wrote:
>> From: Abdul Hussain <habdul@visteon.com>
>>
>> This patch removes casting the values returned by memory allocation functions.
>>
>> Signed-off-by: Abdul Hussain <habdul@visteon.com>
>> ---
>>  drivers/staging/wilc1000/linux_mon.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
> Does not apply :(
>
Greg,

I will verify and resend the patch.

Thanks,
Abdul

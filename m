Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44969 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZJQF7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 01:59:11 -0400
Received: by ewy4 with SMTP id 4so14815ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 22:59:14 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: rename spi device to wl1251
References: <20091013174119.15796.81021.stgit@tikku>
	<1255686697.4095.324.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 17 Oct 2009 08:59:12 +0300
In-Reply-To: <1255686697.4095.324.camel@johannes.local> (Johannes Berg's message of "Fri\, 16 Oct 2009 18\:51\:37 +0900")
Message-ID: <87eip2muhb.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>>  static struct spi_driver wl1251_spi_driver = {
>>  	.driver = {
>> -		.name		= "wl12xx",
>> +		.name		= "wl1251",
>>  		.bus		= &spi_bus_type,
>>  		.owner		= THIS_MODULE,
>
> IIRC there's a preprocessor symbol for the module name (MODULE_NAME?)

Yes, there is DRIVER_NAME macro. I'll send a new patch on top of this
one. Thanks.

-- 
Kalle Valo

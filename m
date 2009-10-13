Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:37208 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZJMUm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 16:42:27 -0400
Message-ID: <4AD4E60E.5030005@pardus.org.tr>
Date: Tue, 13 Oct 2009 23:41:50 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Current status of rt2800usb and staging/rt2870
References: <4AD46380.9020308@pardus.org.tr> <200910131844.58983.bzolnier@gmail.com>
In-Reply-To: <200910131844.58983.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartlomiej Zolnierkiewicz wrote:
> Hi,
>
> On Tuesday 13 October 2009 13:24:48 Ozan Çağlayan wrote:
>   
>> Hi,
>>
>> In 2.6.31, there are USB device IDs common between both drivers. Should
>> a distribution enable both drivers? What do you suggest? Are there any
>> *known issues* stuff for one of them?
>>     
>
> My advice to distributions for such situations is to ship both but make
> one driver the default one.  

By saying to make one driver the default one, you mean avoiding the
other from getting probed automatically by clearing the device id tables?



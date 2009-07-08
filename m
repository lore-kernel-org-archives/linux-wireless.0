Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48269 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbZGHWU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 18:20:27 -0400
Message-ID: <4A551B43.3020104@gmail.com>
Date: Thu, 09 Jul 2009 00:18:43 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Linux wireless <linux-wireless@vger.kernel.org>,
	Przemyslaw Kulczycki <azrael@autocom.pl>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
References: <4A54FB81.30302@gmail.com> <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>
In-Reply-To: <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> On Wed, Jul 8, 2009 at 9:03 PM, Marcin Slusarz<marcin.slusarz@gmail.com> wrote:
>> Different revisions of WUSB54GC-EU use different chipsets -
>> v2 uses rtl8187, but v3 uses Ralink RT3070.
>>
>> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
>> Cc: Przemyslaw Kulczycki <azrael@autocom.pl>
>> Cc: John W. Linville <linville@tuxdriver.com>
>> Cc: Linux wireless <linux-wireless@vger.kernel.org>
>> ---
>>  drivers/net/wireless/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
>> index 5bc00db..7d5902d 100644
>> --- a/drivers/net/wireless/Kconfig
>> +++ b/drivers/net/wireless/Kconfig
>> @@ -431,7 +431,7 @@ config RTL8187
>>          ASUS P5B Deluxe
>>          Toshiba Satellite Pro series of laptops
>>          Asus Wireless Link
>> -         Linksys WUSB54GC-EU
>> +         Linksys WUSB54GC-EU v2
> 
> Is there a v1, and what does it use?

I don't know.

Marcin


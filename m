Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbbEEVkR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 17:40:17 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <55492249.2070900@gmail.com>
Date: Tue, 05 May 2015 17:40:15 -0400
In-Reply-To: <55492249.2070900@gmail.com> (Xose Vazquez Perez's message of
	"Tue, 05 May 2015 22:04:25 +0200")
Message-ID: <wrfj1tiu3dq8.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150505_234022_866169_BEAB36EE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
> Jes Sorensen wrote:
>
>> [...]
>> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
>> index 0c88916..e3911cc 100644
>> --- a/drivers/net/wireless/Makefile
>> +++ b/drivers/net/wireless/Makefile
>> @@ -39,6 +39,8 @@ obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
>>  
>>  obj-$(CONFIG_ADM8211)	+= adm8211.o
>>  
>> +obj-$(CONFIG_RTL8XXXU)	+= rtl8xxxu.o
>> +
>> [...]
>
> rtl8xxxu is a really bad name.
>
> You can see at: https://wireless.wiki.kernel.org/en/users/drivers/rtl819x
> the normalized nomenclature for realtek drivers.

Right, the driver covers USB devices, hence the u at the end of the
name. As I posted elsewhere, I intend to add support for other rtl8xxx
USB chips, hence the 8xxx name.

What is your issue?

Jes

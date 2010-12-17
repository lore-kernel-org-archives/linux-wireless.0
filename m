Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54310 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab0LQTYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 14:24:39 -0500
Received: by wyb28 with SMTP id 28so1000228wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 11:24:38 -0800 (PST)
Message-ID: <4D0BB8EC.7070907@lwfinger.net>
Date: Fri, 17 Dec 2010 13:24:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8192ce: Update MAINTAINERS
References: <4d0a2c91.Nuemy+kBaD1fOuX+%Larry.Finger@lwfinger.net> <4D0BB739.3020700@hauke-m.de>
In-Reply-To: <4D0BB739.3020700@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/17/2010 01:17 PM, Hauke Mehrtens wrote:
> On 12/16/2010 04:13 PM, Larry Finger wrote:
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> Index: wireless-testing/MAINTAINERS
>> ===================================================================
>> --- wireless-testing.orig/MAINTAINERS
>> +++ wireless-testing/MAINTAINERS
>> @@ -5055,6 +5055,16 @@ T:	git git://git.kernel.org/pub/scm/linu
>>  S:	Maintained
>>  F:	drivers/net/wireless/rtl818x/rtl8187*
>>  
>> +RTL8192CE WIRELESS DRIVER
>> +M:	Larry Finger <Larry.Finger@lwfinger.net>
>> +M:	Chaoming Li <chaoming_li@realsil.com.cn>
>> +L:	linux-wireless@vger.kernel.org
>> +W:	http://linuxwireless.org/
>> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>> +S:	Maintained
>> +F:	drivers/net/wireless/rtlwifi/
>> +F:	drivers/net/wireless/rtl8192ce/
> This path is wrong, it should be drivers/net/wireless/rtlwifi/rtl8192ce/
> at least the driver is not in rivers/net/wireless/rtl8192ce/.

Yes, it should be drivers/net/wireless/rtlwifi/rtl8192ce/.

Thanks,

Larry

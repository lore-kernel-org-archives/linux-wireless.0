Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51873 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2GIQMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 12:12:05 -0400
Received: by gglu4 with SMTP id u4so10230209ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 09:12:05 -0700 (PDT)
Message-ID: <4FFB02D1.7050708@lwfinger.net> (sfid-20120709_181211_104229_AE747AB1)
Date: Mon, 09 Jul 2012 11:12:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: realtek drivers
References: <1341844078-2319-1-git-send-email-xose.vazquez@gmail.com> <4FFAF2D8.3070505@lwfinger.net> <4FFAF459.500@gmail.com>
In-Reply-To: <4FFAF459.500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 10:10 AM, Xose Vazquez Perez wrote:
> On 07/09/2012 05:03 PM, Larry Finger wrote:
>
>> On 07/09/2012 09:27 AM, Xose Vazquez Perez wrote:
>
>>> -RTL8192CE WIRELESS DRIVER
>>> +RTLWIFI WIRELESS DRIVERS
>>
>> NACK on this part. Rather than removing rtl8192ce, it should be kept. The new
>> line should be
>>
>> RTLWIFI: RTL8192CE, RTL8192CU, RT8192SE, AND RTL8192DE WIRELESS DRIVERS
>
> What about this one?
>
> RTLWIFI: RTL8192CE/CU/DE/SE WIRELESS DRIVERS

With that one, you cannot grep for RTL8192CU, etc. Do you think that is 
important? I do.

Larry



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42759 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1LKWuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Dec 2011 17:50:35 -0500
Received: by wgbdr13 with SMTP id dr13so9968597wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Dec 2011 14:50:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE3BE7B.5030606@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
	<1323385619-7454-6-git-send-email-frankyl@broadcom.com>
	<CACna6rwVVEYf0F6HZoMKrJg2NT3c4SPb6OH34LsTm8NR+BtsRA@mail.gmail.com>
	<4EE3BE7B.5030606@broadcom.com>
Date: Sun, 11 Dec 2011 23:50:34 +0100
Message-ID: <CACna6rzEQ5hXv6N5xtaLUCt=OvemvPowNJvfe8BAUNXdxDBwkg@mail.gmail.com> (sfid-20111211_235039_278903_3568C035)
Subject: Re: [PATCH 05/23] bcma: add set/mask macros for 16-bit register access
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 10 grudnia 2011 21:18 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 12/10/2011 12:45 PM, Rafał Miłecki wrote:
>> 2011/12/9 Franky Lin <frankyl@broadcom.com>:
>>> From: Arend van Spriel <arend@broadcom.com>
>>>
>>> The BCMA header only had definitions for 32-bit register access. Used
>>> those as a template for the 16-bit flavour. Also changed them to inline
>>> functions to be on the safe side. As offset parameter is used twice there
>>> would be a problem when used like this: bcma_set32(core, offset++, val);
>>>
>>
>> What is an advantage of static inline over define?
>>
>
> Hi Rafał,
>
> Apart from the example given in the commit message the CodingStyle
> documentation states a preference for inline functions. One advantage I
> can come up with is type checking by the compiler.

Thanks for explaining, compiler errors should be indeed nicer. Thanks
for patch :)

-- 
Rafał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62929 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3KBWgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 18:36:46 -0400
Received: by mail-ie0-f180.google.com with SMTP id e14so9731355iej.39
        for <linux-wireless@vger.kernel.org>; Sat, 02 Nov 2013 15:36:45 -0700 (PDT)
Message-ID: <52757E7A.6020404@gmail.com> (sfid-20131102_233649_501058_01969CE7)
Date: Sat, 02 Nov 2013 18:36:42 -0400
From: Alexandre Demers <alexandre.f.demers@gmail.com>
Reply-To: alexandre.f.demers@gmail.com
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: r92su: status and will it be merged anytime soon?
References: <52755E44.1060501@gmail.com> <5275745F.9080002@lwfinger.net>
In-Reply-To: <5275745F.9080002@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, so if I was to work on one of the drivers, I should continue with 
the one under staging, isn't it? Because, let's say I would have some 
spare time to invest somewhere, I could port the driver to use mac80211, 
maybe with some support. I'd prefer to do it only once... on the good 
driver.

Alexandre Demers

On 11/02/2013 05:53 PM, Larry Finger wrote:
> On 11/02/2013 03:19 PM, Alexandre Demers wrote:
>> Good afternoon,
>>
>> I was playing in r8712u because I wanted to send a patch to 
>> conditionally
>> silence a flooding netdev_info(). But then I found out on
>> http://wireless.kernel.org/en/users/Drivers/rtl819x that r8712u was 
>> to be
>> replaced by r92su.
>>
>>  From its git tree, it seems no commit were added since 4 months ago. 
>> Could
>> someone tell me in what shape is this new driver? Is there any plan 
>> to merge it
>> (under staging I suppose) soon?
>
> As nothing has happened with that GitHub account for several months, 
> my guess is that it will not be merged any time soon.
>
> It would make little sense to replace one staging driver (r8712u) with 
> a different one. The only thing that makes sense is for it to use 
> mac80211 and be merged in the regular drivers/net/wireless/rtlwifi tree.
>
> Larry
>
>


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39972 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZIBRLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 13:11:11 -0400
Received: by ewy2 with SMTP id 2so1040590ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 10:11:11 -0700 (PDT)
Message-ID: <4A9EA72A.3010504@gmail.com>
Date: Wed, 02 Sep 2009 13:11:06 -0400
From: Jeremy Wolcott <jeremy.wolcott@gmail.com>
MIME-Version: 1.0
To: tim.gardner@canonical.com
CC: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless and DKMS
References: <4A9E7FBE.6060705@gmail.com> <4A9E9AEE.4060409@canonical.com>
In-Reply-To: <4A9E9AEE.4060409@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh, cool.  Is that in the Jaunty repositories?  The latest kernel 
release I'm seeing (with -proposed and -backports enabled) is 2.6.28-15...

Thanks,

-Jeremy

Tim Gardner wrote:
> Jeremy Wolcott wrote:
>> Has anybody tried to get compat-wireless working with DKMS?  This 
>> would be really handy for me since I run Ubuntu and they have been 
>> pushing kernel updates pretty frequently lately, but I need the newest 
>> compat-wireless to run my Atheros card in master mode via ath5k...
>>
>> I tried for quite a while today and the build just won't work.  (The 
>> 'make clean' step returns error 2, and then the build itself fails 
>> with "(directory it's building in) is a directory.  Stop.")  I think 
>> it's because the Makefile for compat-wireless uses the PWD environment 
>> variable, but I'm not well-versed enough in Makefiles to fix it up so 
>> that it'll work from a different directory (DKMS builds modules in 
>> /var/lib/dkms/MODULE_NAME/VERSION/build instead of wherever I unpacked 
>> the source).
>>
>> Any advice would be appreciated...
>>
>> Thanks,
>>
>> -Jeremy
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I've been packaging compat-wireless in linux-backports-modules-2.6.31 on 
> a semi-spasmodic basis. Current version contains wireless-testing 
> master-2009-09-01.
> 
> rtg

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40541 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1DRI5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 04:57:53 -0400
Received: by fxm17 with SMTP id 17so2778565fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 01:57:52 -0700 (PDT)
Message-ID: <4DABFD08.3070806@gmail.com>
Date: Mon, 18 Apr 2011 11:57:44 +0300
From: Alex <alfragk@gmail.com>
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@kepstin.ca>
CC: linux-wireless@vger.kernel.org
Subject: Re: crda fails to compile
References: <4DA8163F.6040308@gmail.com> <1302979775.17255.4.camel@nayuki>
In-Reply-To: <1302979775.17255.4.camel@nayuki>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/4/2011 9:49 μμ, Calvin Walton wrote:
> On Fri, 2011-04-15 at 12:56 +0300, Alex wrote:
>> Hi,
>>
>> the last couple of days i've beeen trying to compile crda on my linux
>> box (gentoo) without success.
>>
>> I've downloaded crda-1.1.1, and i've installed all the requirements as
>> described in the README file.
>>
>> However, when i run make i get the following error:
>>
>> GEN  keys-gcrypt.c
>>     Trusted pubkeys: pubkeys/linville.key.pub.pem
>>     File "./utils/key2pub.py", line 6
>>       except ImportError, e:
>>                         ^
>> SyntaxError: invalid syntax
>> make: *** [keys-gcrypt.c] Error 1
>>
>>
>> Any help would be appreciated,
> My guess is that your system installation of python (/usr/bin/python) is
> actually python-3 instead of python-2. The two versions are
> incompatible: a python-2 script won't run on python-3 without porting.
>
> On gentoo you can switch your default python version back to 2 by
> running the commands:
>
> # eselect python list
> Available Python interpreters:
>    [1]   python2.7
>    [2]   python3.1 *
> # eselect python set 1
>
> Also note that gentoo has a crda package available which you could use
> instead (I'd recommend this if you're not trying to develop crda):
>
> emerge net-wireless/crda
>
> Hope that helps.

Thanks it works now!

Alex

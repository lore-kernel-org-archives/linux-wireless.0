Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from llsa731-a03.servidoresdns.net ([82.223.190.25]:56070 "EHLO
        llsa731-a03.servidoresdns.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750946AbdBHUNi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 15:13:38 -0500
Subject: Re: Installing driver for Ubuntu 16.04 Intel(R) Wireless WiFi Link
 4965AGN
To: sedat.dilek@gmail.com
References: <CA+icZUXtJG18ejLynO1FB0BS5Guqr35-Bn0_Obht-VyGNO4tAg@mail.gmail.com>
 <6df84be9db053beae03eb31ece0ab2d7@mail.leopoldosoria.com>
 <CA+icZUVZ5mz4NmvrQit3Mz3GEbobR265Yd8YjVKF90=MBNQkAQ@mail.gmail.com>
 <db60d707-1cfe-f9b1-8d63-87e0121101e4@leopoldosoria.com>
 <ee13dae1-d01f-baff-a4d3-fe3e77fa85ec@leopoldosoria.com>
 <CA+icZUV-J0+jY8U=5_UwDf1Z7Qgnqswn+gAPhWm8YYkhqWLJjw@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Leopoldo <info@leopoldosoria.com>
Message-ID: <ecfcf4da-aa7c-a451-6642-5ff05a6d9fe9@leopoldosoria.com> (sfid-20170208_211424_786373_1BB4104A)
Date: Wed, 8 Feb 2017 21:12:01 +0100
MIME-Version: 1.0
In-Reply-To: <CA+icZUV-J0+jY8U=5_UwDf1Z7Qgnqswn+gAPhWm8YYkhqWLJjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Sedat,

Absolutely clear. As you are my primary contact there, you can extent my 
question to the people there.

I much appreciate your assistance.

Kind regards,

Leopoldo


El 06/02/17 a las 07:01, Sedat Dilek escribió:
> On Sun, Feb 5, 2017 at 6:31 PM, Leopoldo <info@leopoldosoria.com> wrote:
>> Dear Sedat,
>>
>> Did you have the chance to have a look to this?
>>
> No.
> If it was not clear said: I did not promise to look at it, I just said
> sent the logs and people here can look at it.
>
> - Sedat -
>
>> Kind regards.
>>
>> Leopoldo
>>
>>
>> El 16/01/17 a las 21:33, Leopoldo escribió:
>>
>> Dear Sedat,
>>
>> Please, find attached the requested 2 files.
>>
>> Thanking you invaluable collaboration.
>>
>> Leopoldo
>>
>>
>> El 02/01/17 a las 20:39, Sedat Dilek escribió:
>>
>> On Mon, Jan 2, 2017 at 7:11 PM,  <info@leopoldosoria.com> wrote:
>>
>> Dear Madam Sedat,
>>
>> Hehe, my family name is indeed a female first name - Sedat is male.
>>
>> Thank you for your answer.
>>
>> I already consulted Ubuntu Community but it is not so nice for a beginner
>> like me. I tried several recomedations from them, but no way.  So, I
>> thought, it is better to ask to the source.
>>
>> Yes, I have the firmware you mention, but wifi doesn't work. The icon appear
>> in the top bar but it doesn't seem to be conected. It doesn't seach
>> conections even when wifi is activated. The ligh of wifi simbol in the
>> laptop lights some times but others it doesn't.
>>
>> It's difficult to answer without knowing anything about your hardware,
>> your WLAN infrastructure and your WLAN setup on Ubuntu/xenial.
>>
>> It might be helpful if you attach your linux-config and dmesg output.
>>
>> $ cp -v /boot/config-$(uname -r) /tmp
>> $ dmesg > /tmp/dmesg.txt
>>
>> Attach those two files from /tmp directory and people can look at this.
>>
>> - Sedat -
>>
>> Any help is welcome and I won't forget ladies next time, sorry.
>>
>> Thank you for your help and have a happy new year 2017 also.
>>
>> Regards,
>> Leopoldo
>>
>>
>>
>>
>> El 02-01-2017 15:06, Sedat Dilek escribió:
>>
>> On Mon, Jan 2, 2017 at 2:11 PM,  <info@leopoldosoria.com> wrote:
>>
>> Dear Sirs,
>> Which of the below drivers should I install for my Lenovo 3000 V200?
>> I am runing Ubuntu 16.04
>>
>> Intel® Wireless WiFi Link 4965AGN
>> 2.6.24+ iwlwifi-4965-ucode-4.44.14.tgz
>> 2.6.24+ iwlwifi-4965-ucode-4.44.15.tgz
>> 2.6.24+ iwlwifi-4965-ucode-4.44.17.tgz
>> 2.6.24+ iwlwifi-4965-ucode-4.44.1.18.tgz
>> 2.6.24+ iwlwifi-4965-ucode-4.44.1.20.tgz
>> 2.6.24+ iwlwifi-4965-ucode-228.57.1.21.tgz
>> 2.6.28+ (?)     iwlwifi-4965-ucode-228.57.2.21.tgz
>> 2.6.28+ (?)     iwlwifi-4965-ucode-228.57.2.23.tgz
>> 2.6.28+ (?)     iwlwifi-4965-ucode-228.61.2.24.tgz
>>
>> Ans how shoudl I proceed for intalling the right driver?
>>
>> Thank you
>>
>> [ What about the Ladies, Sir :-)? ]
>>
>> Happy new 2017!
>>
>> You need the linux-firmware [1] package.
>> Normally, Ubuntu/xenial should ship it.
>>
>> Check if you have...
>>
>> /lib/firmware/iwlwifi-4965-2.ucode
>>
>> ...file.
>>
>> Not sure why you are asking or what is not working.
>> AFAICS, Ubuntu should have some nice wikis explaining a WLAN setup.
>> A good strategy will always be to consult your distro's help before asking
>> here.
>>
>> [3] as a gift.
>>
>> Regards,
>> - Sedat -
>>
>> [1] http://packages.ubuntu.com/xenial/linux-firmware
>> [2] http://packages.ubuntu.com/xenial/all/linux-firmware/filelist
>> [3] http://www.catb.org/~esr/faqs/smart-questions.html
>>
>>
>>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:53538 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761277AbYDAVCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 17:02:50 -0400
Received: by fk-out-0910.google.com with SMTP id 19so3066643fkr.5
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 14:02:47 -0700 (PDT)
Message-ID: <47F2A2F0.4060908@gmail.com> (sfid-20080401_220340_496900_FA324F7F)
Date: Tue, 01 Apr 2008 23:02:40 +0200
From: Luca Venturini <lucventurini@gmail.com>
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: New IWL4935 driver for Intel Wireless Cards does not support
 WPA2 wireless network with PEAP - MSCHAPV2
References: <47F1F4F4.2080502@gmail.com> <20080401164419.GA3530@tuxdriver.com> <5d75f4610804011306y55352e73sb5223a294b66f2cf@mail.gmail.com>
In-Reply-To: <5d75f4610804011306y55352e73sb5223a294b66f2cf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I hope, then, that Linux 2.6.25.x stable will be out sooner than 24th 
april (Hardy release date) otherwise I (and I guess also many other 
people) will be in a very bad spot until the kernel is updated...(I am 
not proficient enough so to compile a whole Linux kernel for my distro).
Thank you very much for your attention, in any case.
Greetings
Luca Venturini

BuraphaLinux Server ha scritto:
> intel wireless just doesn't work on linux 2.6.24.4; wait for 2.6.25.x stable.
>
> On 4/1/08, John W. Linville <linville@tuxdriver.com> wrote:
>   
>> You probably want to address this to linux-wireless@vger.kernel.org
>> instead...
>>
>> On Tue, Apr 01, 2008 at 10:40:20AM +0200, Luca Venturini wrote:
>>     
>>> Using Ubuntu Hardy Beta, Linux kernel 2.6.24, AMD64.
>>> I have to connect to a campus (University of Verona, Italy; more
>>> information maybe available at https://wifi.univr.it sadly in Italian
>>>       
>> only,
>>     
>>> and I am not sure it is reachable from outside the university) WPA2
>>> wireless network. It uses PEAP authentication, Dynamic WEP encryption,
>>> second phase: MSCHAPv2.
>>> It also requires user login, password, and a CA certificate (available at
>>> the web page I linked above).
>>> At the same page a wpasupplicant configuration file is also available, so
>>> to allow people to connect from linux also.
>>> In Ubuntu Gutsy 32 bit (Linux kernel 2.6.22.14 if I am not mistaken) I was
>>> able to connect through NetworkManager and precisely using the GNOME
>>> nm-applet.
>>> However, since I switched to Linux 2.6.24, I have no more been able to
>>> connect, whether through NM-applet or from the command line, using
>>> wpasupplicant. The wireless functions perfectly, and there has been no
>>> change in its configuration, since I am using it now (Windows Vista,
>>> configured months ago).
>>> Reported also here on launchpad:
>>> https://bugs.launchpad.net/ubuntu/+bug/209602
>>> Thank you for your attention.
>>> Greetings
>>>
>>> Luca Venturini
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>       
>> --
>> John W. Linville
>> linville@tuxdriver.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     


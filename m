Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35175 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbbJ1LxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 07:53:12 -0400
Received: by qgbb65 with SMTP id b65so3575571qgb.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 04:53:11 -0700 (PDT)
MIME-Version: 1.0
Reply-To: srikanth007m@gmail.com
In-Reply-To: <CABXAfNKcvnkLJ3DhgwbbTHjLtchmEbppJqz=e8orv=WtmbDqPg@mail.gmail.com>
References: <CANKSX+FQZpzz4KvYP3mwb3YJKUqCi-_sxSBpd1+13KtswSjsPw@mail.gmail.com>
	<CABXAfNKcvnkLJ3DhgwbbTHjLtchmEbppJqz=e8orv=WtmbDqPg@mail.gmail.com>
Date: Wed, 28 Oct 2015 17:23:11 +0530
Message-ID: <CANKSX+Etmy03SPunfXOpbx_GQ+zWEK+wPxY=MPij3r3tsQU+jw@mail.gmail.com> (sfid-20151028_125316_748372_DADB9FDA)
Subject: Re: Wifi test suite
From: "$rik@nth " <srikanth007m@gmail.com>
To: punit vara <punitvara@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These won't precisely test the wlan/connectivity modules. AFAIK these
are for testing overall linux kernel and its syscalls. What i am
looking is for especially that tests the wlan functional cases.

On Wed, Oct 28, 2015 at 5:17 PM, punit vara <punitvara@gmail.com> wrote:
>
> On 28 Oct 2015 12:50, "$rik@nth" <srikanth007m@gmail.com> wrote:
>>
>> Hi All,
>>
>> I am new to wireless developing. Before submitting the patches i would
>> like to test on my workstation. So is there any test suite or
>> regression suite available for WiFi or BT in order to check the
>> changes aren't breaking the basic workflow.
>>
>> I've tried to get the listed ones on [1]. But those git links are
>> broken. It would be great if someone points to any existing one is
>> available.
>>
>> [1] http://linuxwireless.org/en/developers/Testing/wifi-test/#Wifi-test
>> --
>> Thanks & Regards,
>> M.Srikanth Kumar.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Checkout
>
> http://github.com/linux-test-project/ltp
>
> http://github.com/autotest/autotest



-- 
Thanks & Regards,
M.Srikanth Kumar.

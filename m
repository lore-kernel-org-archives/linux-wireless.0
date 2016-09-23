Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:33168 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034692AbcIWSq3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 14:46:29 -0400
Received: by mail-ua0-f171.google.com with SMTP id u68so54653733uau.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2016 11:46:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rwshvB1xPXwdzpJS7uDz-zWWa=pV29B=0J9JJW+GKUx6g@mail.gmail.com>
References: <CA+PvwyEA-U2OeTrGW+d8B_sEHZYdaM3J79ZcpcC=89MvvYsrCw@mail.gmail.com>
 <CACna6rwshvB1xPXwdzpJS7uDz-zWWa=pV29B=0J9JJW+GKUx6g@mail.gmail.com>
From: David Petrizze <dpetrizze@gmail.com>
Date: Fri, 23 Sep 2016 12:45:58 -0600
Message-ID: <CA+PvwyGUF8a3FPpQVkHLMsT=YdD=LwN6bqKfZBO7=KZEv+UpgA@mail.gmail.com> (sfid-20160923_204633_392793_7F1882EF)
Subject: Re: Broadcom Firmware Rollback
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see. I guess I was hoping for some sort of mishap i.e. replacing
6.20 with 6.30 without thinking. If it wasn't released, I'll keep
working on compiling the Ubuntu driver I did find.

Thanks again

On Thu, Sep 22, 2016 at 10:48 PM, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com=
> wrote:
> On 23 September 2016 at 04:43, David Petrizze <dpetrizze@gmail.com> wrote=
:
>> I'm having issues with broadcom's latest firmware / driver, version
>> 6.30.163.46. Wireless is solid for about a minute, and then drops
>> completely. My research has led me to believe my chip (BCM4331) is no
>> longer supported under 6.30.X.X, or has a bug somewhere. I want to
>> roll back to the firmware that worked.
>>
>> What I'm looking for is a file named broadcom-wl-6.20.*.*.tar.bz2. I
>> found my current firmware from http://www.lwfinger.com/b43-firmware/,
>> but 6.20.X.X is nowhere to be found. 5.100.X.X is there, but the 4331
>> definitely wasn't supported for that one.
>>
>> Inside each of these archives on lwfinger is a file called wl_apsta.o,
>> where the firmware is extracted from.  Since b43-fwcutter only
>> extracts firmware from versions of wl_apsta.o that match specific
>> MD5's, I figure 6.20.X.X has to be out there somewhere.
>>
>> More info can be found from my original post:
>> https://bbs.archlinux.org/viewtopic.php?id=3D217326
>>
>> ...and other people confrim 6.30.X.X being a problem in this ubuntu bug:
>> https://bugs.launchpad.net/ubuntu/+source/bcmwl/+bug/1189611
>>
>> If anyone could point me in the right direction, I would be immensely gr=
ateful.
>
> You can't make proprietary driver using firmware of your choice, so
> don't bother looking at MIPS drivers stored at Larry's server.
>
> You just need to find a /complete/ (mostly closed source of course)
> driver 6.20 for x86/x86_64. I don't think it was ever published on
> Broadcom's site, I think it was made available to Ubuntu only under
> some agreement. So keep looking at Ubuntu resources.
>
> Also linux-wireless ML focuses on open source drivers, so you may have
> more luck asking at Ubuntu community.
>
> --
> Rafa=C5=82

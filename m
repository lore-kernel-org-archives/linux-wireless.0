Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35738 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754229AbdCTPLA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 11:11:00 -0400
Received: by mail-oi0-f53.google.com with SMTP id a94so23799473oic.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 08:10:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <34e317ae-a112-79bc-41ef-c18433e8cc49@lwfinger.net>
References: <CADND2bqVLdSmmY=RG7m8r2maWyc7yGgvKUO4O4YGPLVnMx0pqg@mail.gmail.com>
 <34e317ae-a112-79bc-41ef-c18433e8cc49@lwfinger.net>
From: Fernanda Vejar <fvejar85@gmail.com>
Date: Mon, 20 Mar 2017 12:10:06 -0300
Message-ID: <CADND2bprCVNThAWVp-De7W3uRvKNDxGrxEond2ANZ+=2akKB_Q@mail.gmail.com> (sfid-20170320_161559_882581_A009FF07)
Subject: Re: Wireless failed
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

thank you very much for your response.

I'm using "Trisquel 7.0 LTS Belenos" since a few days.
My kernel version is acoording to "uname -r" : "3.13.0-112-lowlatency".
By "lspci --n"n I have found : "01:00.0 Network controller [0280]:
Intel Corporation Centrino Wireless-N 2230 [8086:0887] (rev c4)".
There is no evidence of iwlwifi by running" lsmod".
According to "dmesg | less", I've found: "Linux version
3.13.0-112-lowlatency (pbuilder@devel.trisquel.info) (gcc version
4.8.4 (Ubuntu 4.8.4-2ubuntu1~14.04.3) ) #159+7.0trisquel2 SMP PREEMPT
Mon Mar 13 13:58:08 UTC 2017 (Ubuntu
3.13.0-112.159+7.0trisquel2-lowlatency 3.13.11-ckt39-gnu)", I think it
could clarify a little more. But I can't see more relevant issue given
by this command.

I don't know if the problem is to be solved. Maybe I should try a new distr=
o.

Fernanda.

2017-03-19 23:03 GMT-03:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 03/19/2017 12:15 PM, Fernanda Vejar wrote:
>>
>> Dear Sir or Madam, I am writing you because I cannot make the wireless
>> connection work. I have just installed a new Linux operative system
>> which has no driver for the wireless card. I have the device "Intel
>> Centrino Wireless-N 2230" into my computer and I have been trying to
>> follow the instructions given by "wireless.wiki.kernel" with the
>> following steps: 1) I installed the corresponding firmware
>> "iwlwifi-2030-ucode-18.168.6.1.". 2) I installed the driver LinuxCore5
>> as indicated and rebooted. 3) As I found no change, I have noted that
>> the hostap was absent. Than I cloned it. 4) Since it also didn't work,
>> I took "linux-firmware" and I installed "-9 ucode: 7260, 3160, 7265"
>> at /lib/firmware. I think I maybe did something wrong, but I don't
>> know how can I undo all these steps and try again. I really hope you
>> can give me some hint. Thank you very much in advance. Best Regards,
>> Fernand Vejar
>
>
> I have nothing to do with any Intel wireless drivers, but I will give you
> some advice regarding your problem.
>
> Whenever you are reporting a problem, you must ABSOLUTELY specify the dis=
tro
> and version of your Linux. You should also specify the kernel version as
> shown by the "uname -r" command. It is also helpful if you specify the
> wireless hardware by posting the appropriate stanza from the "lspci -nn"
> command.
>
> The above will verify what device you have, but the most probable driver =
is
> iwlwifi, which has been in the kernel for a very long time. I would be ve=
ry
> surprised if any distributed kernel did not have this driver available. Y=
ou
> can run the lsmod command to see if the driver is loaded. You should also
> check the log using "dmesg | less" to see if the firmware is missing.
>
> Larry
>
> --
> If I was stranded on an island and the only way to get off
> the island was to make a pretty UI, I=E2=80=99d die there.
>
> Linus Torvalds

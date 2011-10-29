Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33526 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1J2MG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Oct 2011 08:06:27 -0400
Received: by wwe6 with SMTP id 6so6960162wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 29 Oct 2011 05:06:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA9E56D.5080300@lwfinger.net>
References: <CAF7qGM4BL10gn2786kW73sAk8f-y8CzX0rx2BQsY_Q96W=pfog@mail.gmail.com>
 <4EA89B8D.7060104@lwfinger.net> <CAF7qGM7hfaz0SGiZVZ62r_nPO8viMT5F2_Kd1uRxN9Ha3mRO+Q@mail.gmail.com>
 <4EA97323.50004@lwfinger.net> <CA+XFjipvGBsWCCWt5OvFfeCiOpsH28Txvui4A+d8sVCaACQ57Q@mail.gmail.com>
 <4EA9E56D.5080300@lwfinger.net>
From: Roman Proud <setamagiga@gmail.com>
Date: Sat, 29 Oct 2011 14:06:05 +0200
Message-ID: <CAF7qGM5Zmd55B6VPWfEwACgCHuAOyhCYRXwNwi8TTOQ-BD-pmA@mail.gmail.com> (sfid-20111029_140633_035471_042A148B)
Subject: Re: RTL8188RU no injection?
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I really thank you guys for helping me.
I really learned a lot in this thread xD

Its an ALFA AWUS036NHR so i guess its me... but yeah, i also found
that there are many drivers already in the main kernel, but i didnt
know there is a difference between rtl and r and nothing ...

Btw i tried many drivers, not only directly from Realtek. I think my
netbook kernel, was the problem, since i'm on Orginal Arch im getting
straight forward to get this thing working :D

Now where i know that it should work, i can try and try without
worrying that it never will work, so really thx for testing this!

Greetings,
Roman

2011/10/28 Larry Finger <Larry.Finger@lwfinger.net>:
> On 10/27/2011 05:00 PM, Gábor Stefanik wrote:
>
>> As a former Aircrack developer, I can definitely state that Aircrack
>> uses the same injection method as packetspammer.
>
> I just built Aircrack and tested it with rtl8192cu on an ALFA AWUS036NHR,
> which has the RTL8188RU chip. It works just as you expected.
>
> Larry
>
>
>

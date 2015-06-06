Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36235 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbFFPTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 11:19:42 -0400
Received: by pabqy3 with SMTP id qy3so67108022pab.3
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jun 2015 08:19:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bngtnf00.fsf@kamboji.qca.qualcomm.com>
References: <CAGm1_kt1FfO=juFvwRP6CQU7_YTf2WQcQEgHfNAVkW=PSKMAzQ@mail.gmail.com>
 <87bngtnf00.fsf@kamboji.qca.qualcomm.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Sat, 6 Jun 2015 17:19:21 +0200
Message-ID: <CAGm1_ku=YSQw5W11=NJA79pgPN8ptfE4iv8CCuXR1DTz=9JLAQ@mail.gmail.com> (sfid-20150606_172301_818212_C07F1DD6)
Subject: Re: wl18xx: wlconf kernel compatibility
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Machani, Yaniv" <yanivma@ti.com>, Eliad Peller <eliad@wizery.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Sat, Jun 6, 2015 at 3:27 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Yegor Yefremov <yegorslists@googlemail.com> writes:
>
>> How do I know, which wlconf version is compatible with which kernel
>> version? I have following problem:
>>
>> I have *.INI file for my particular WLAN chip. This file will be used
>> to produce wl18xx-conf.bin. The size of this file will be check during
>> device initialization. Depending on which kernel version is used the
>> size of the required file differs. For example kernel 3.18 requires
>> wl18xx-conf.bin to have 1221 bytes, 4.1 expects 1226 bytes. Recent
>> wlconf (git://git.ti.com/wilink8-wlan/18xx-ti-utils.git) produces 1229
>> bytes files.
>>
>> How should I determine correct wlconf version?
>
> I also complained about something along these lines earlier, this is not
> how upstream drivers are supposed to work. Users should not be forced to
> find correct files from somewhere, instead everything should just work
> out of box.
>
> Can anyone help Yegor to solve his problem? But in the long run wl18xx
> really should manage this better.

I could solve the problem, though for the future it should be clear,
what wlconf version to use.

See my post here:
http://e2e.ti.com/support/wireless_connectivity/f/307/p/426229/1523235#1523235

Yegor

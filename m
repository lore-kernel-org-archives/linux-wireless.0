Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49454 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1JUXgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 19:36:14 -0400
Received: by qyk27 with SMTP id 27so4377463qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 16:36:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALVkfMpoyY9j3g3GjnWAdvZSuWMjDQT-m1HAMtJJMJXy2pot+A@mail.gmail.com>
References: <CALVkfMpoyY9j3g3GjnWAdvZSuWMjDQT-m1HAMtJJMJXy2pot+A@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 22 Oct 2011 01:35:53 +0200
Message-ID: <CA+XFjioT_JsHfFG89no21S7iLDA8bd_kRSTaHM+HPe-=Z6TiBw@mail.gmail.com> (sfid-20111022_013620_675583_B49B556F)
Subject: Re: where to find ipw2200 driver files for backtrac 5
To: =?ISO-8859-1?Q?Patrick_Tr=E9panier=2DGravelle?=
	<ptrepanierg@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm pretty sure BackTrack 5 has the ipw2200 driver included already.

Try "modprobe ipw2200".

2011/10/22 Patrick Trépanier-Gravelle <ptrepanierg@gmail.com>:
> I cant find the driver for my dell inspiron 700m laptop I tried the
> NDISSwrapper method but I cant extract the .inf file from the .EXE
> seems it isn't the right type of file.
> I would like to know where I could find the linux native drivers for
> ipw2200bg card.
>
> Thank you,
>
> Patrick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

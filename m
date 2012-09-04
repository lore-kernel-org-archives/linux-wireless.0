Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46530 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab2IDBDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 21:03:07 -0400
Received: by obbuo13 with SMTP id uo13so10071095obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2012 18:03:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=sqB24R2RORbj1ArCe0mKAeoj-wUOnMkdoVGM_FyiaDQ@mail.gmail.com>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<CAJ-Vmo=kzUW=PTRMDpxVf-pQVdozC5U_g-GPyFQ+vkRTFhe1dw@mail.gmail.com>
	<CAEFj985FB5PhGRqWfzpsN46Y1YdAw42w+_u4EBzUfP1vjswCnQ@mail.gmail.com>
	<CAJ-Vmo=sqB24R2RORbj1ArCe0mKAeoj-wUOnMkdoVGM_FyiaDQ@mail.gmail.com>
Date: Tue, 4 Sep 2012 09:03:07 +0800
Message-ID: <CAEFj985B8bbygaA6CkmTmJcOVapLyiSPVhmZGeG_6FUHouZddA@mail.gmail.com> (sfid-20120904_030312_171960_E268733B)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Adrian

I have tested with secured mesh on AR5213A, AR5413 and AR2413/AR2414.
It seems work for me.

> I suggest that you at least wrap this in a run-time configuration item
> that defaults to off or something.
Yes, I do agree on this. But if more peoples are able to test it and
confirm, it would be better.

Thanks

Regards,
Chun-Yeow

On Tue, Sep 4, 2012 at 3:24 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 31 August 2012 08:24, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> Hi, Adrian
>>
>> Appreciate your testing on this.
>>
>
> Hi,
>
> I don't have time to test ath5k stuff. I'm just an Atheros employee
> who hacks on FreeBSD in his spare time. I'm lurking to provide
> feedback. :-)
>
> I suggest that you at least wrap this in a run-time configuration item
> that defaults to off or something. i'd be really worried about this
> stuff having subtle bugs that aren't well documented; it may work for
> you but it may induce weird behaviour in other setups.
>
>
>
> Adrian

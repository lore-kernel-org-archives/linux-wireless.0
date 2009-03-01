Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:52017 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZCAT7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 14:59:12 -0500
Message-ID: <48082.82.152.175.172.1235937549.squirrel@www.phantomjinx.co.uk> (sfid-20090301_205916_243550_549E93AA)
In-Reply-To: <49AAE22A.3080808@lwfinger.net>
References: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>
    <499B27A4.30708@lwfinger.net>
    <42781.82.152.175.172.1234911183.squirrel@www.phantomjinx.co.uk>
    <499B4526.1030705@lwfinger.net>
    <44177.82.152.175.172.1235088928.squirrel@www.phantomjinx.co.uk>
    <499E1826.8040903@lwfinger.net>
    <56183.82.152.175.172.1235173364.squirrel@www.phantomjinx.co.uk>
    <499F4763.70106@lwfinger.net>
    <60836.82.152.175.172.1235929727.squirrel@www.phantomjinx.co.uk>
    <49AAE22A.3080808@lwfinger.net>
Date: Sun, 1 Mar 2009 19:59:09 -0000 (UTC)
Subject: Re: rtl8187 performance diagnostics
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

>> Is there anything I can do to help improve this situation? These res=
ults
>> seems to rule out hardware in favour of being driver related. Are th=
ere
>> other tests I could perform to determine where the fragility lies?
>>
>> Any thoughts, let me know.
>
> OK, the Windows driver is better than the Linux one. Unfortunately, s=
ource
> is not available.

Unsurprisingly, I imagine that the windows environment was what the
manufacturer had in mind. I mean no disrespect to anyone regarding thes=
e
tests. They simply serve to rule out hardware failures and mean that I =
can
help in my probably small and naive way to improve the driver.

> You can check what we did when the RTL8187B was implemented. To do th=
at,
> you
> need to download the Realtek vendor-written Linux driver and check wh=
at
> they do
> against what is in the current in-kernel driver. The critical areas w=
ill
> likely
> be associated with power settings for the radio. Be aware that their =
code
> is
> quite difficult to read as it has multiple conditional compilations t=
hat
> are
> hard to keep straight.

Okay, I shall see how I go. I doubt my ability to come up with somethin=
g
awe inspiring but if I can help and contribute then I shall make it a
point.

> I will be happy to test any improvements that you suggest.

Thanks

PGR

--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

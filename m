Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:45191 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZBVMar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 07:30:47 -0500
Message-ID: <54287.82.152.175.172.1235305844.squirrel@www.phantomjinx.co.uk> (sfid-20090222_133051_958324_80C19A5D)
In-Reply-To: <499F4763.70106@lwfinger.net>
References: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>
    <499B27A4.30708@lwfinger.net>
    <42781.82.152.175.172.1234911183.squirrel@www.phantomjinx.co.uk>
    <499B4526.1030705@lwfinger.net>
    <44177.82.152.175.172.1235088928.squirrel@www.phantomjinx.co.uk>
    <499E1826.8040903@lwfinger.net>
    <56183.82.152.175.172.1235173364.squirrel@www.phantomjinx.co.uk>
    <499F4763.70106@lwfinger.net>
Date: Sun, 22 Feb 2009 12:30:44 -0000 (UTC)
Subject: Re: rtl8187 cannot fix rate
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 > I'm not an expert in reading these tables, but the success rates abo=
ve 11
> Mb/s
> are very low, which seems to indicate that 11 Mb/s is a reasonable ra=
te
> for your
> device. There is, however, a possibility that the code is not reporti=
ng
> the
> retry count correctly. I know from your initial post that 54M doesn't
> work, but
> can you get any throughput at 24, 36, or 48M? There is also the
> possibility that
> your hardware is broken for OFDM encoding. That scheme is used for 6,=
 9,
> and all
> rates 18M and above.

Minimal throughput for fixed rate of 6M. Pinging only replies to every =
4th
packet or so. No ping replies at all for 9, 18, 24, 36, 48 or 54.

Not sure what the actual rate of packet delivery is (doesnt seem slower
than my other laptop) but can confirm with iperf later.

Could also dump an XP installation on here to confirm whether this is a=
n
hardware issue.

Regards

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

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:37503 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZBBP4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 10:56:33 -0500
Message-ID: <35040.82.152.223.193.1233590184.squirrel@www.phantomjinx.co.uk> (sfid-20090202_165635_765636_FE22B5C6)
In-Reply-To: <49871083.5040309@lwfinger.net>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
    <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>
    <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>
    <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>
    <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com>
    <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk>
    <49871083.5040309@lwfinger.net>
Date: Mon, 2 Feb 2009 15:56:24 -0000 (UTC)
Subject: Re: rtl8187 wireless issues
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> P.G. Richardson wrote:
>> That is a fair possibility. I upgraded the kernel on Saturday hence =
I
>> had
>> to rebuild against the new kernel. Upon install, I noticed that rtl8=
187
>> was correctly installed. Of course, this second time of building and
>> installing, I had removed the blacklist entries for rtl8187 as I had
>> successfully used it for 24 hours.
>>
>> One minor point, I notice in iwconfig is that it doesnt report a bit
>> rate
>> of greater than 1Mb/sec. Is this a known issue?
>
> Please excuse my jumping into this thread, but the rate-setting
> problem should be fixed in the latest compat-wireless. What version
> are you using?
>
> I just looked back at the patch log for wireless-testing. To get the
> best code for the RTL8187, you should have compat-wireless from no
> earlier than Jan. 28.
>
> Larry

Thanks for letting me know. Compat-wireless dated 30/01/2009.

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

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:58176 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYDXKhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 06:37:55 -0400
Received: from [62.189.241.202] (helo=[10.104.10.102])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Joypu-0002G2-E2
	for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2008 11:37:54 +0100
Message-ID: <48106301.6070400@fenrir.org.uk> (sfid-20080424_123828_697709_C9F45332)
Date: Thu, 24 Apr 2008 11:37:53 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: 11h IE conflicts with 11s
References: <1ba2fa240804221003o25515740r71c3210d3c9ffb91@mail.gmail.com>	 <1208885207.31429.43.camel@johannes.berg>	 <1ba2fa240804221723l51b8c9a1qa301ededf6c11336@mail.gmail.com>	 (sfid-20080423_022441_945194_1DBEBEB3) <1208978570.3357.1.camel@johannes.berg>
In-Reply-To: <1208978570.3357.1.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>>>  Heh. Interesting. I just looked at the ANA spreadsheet
>>>  (=EF=BB=BF11-08-0227-00-0000-ana-database-assigned-numbers.xls) an=
d there TGs
>>>  doesn't even have any tentative assignments although all other TGs=
 do.
>>>  But TGh is still listed there rather than being subsumed into
>>>  802.11-2007, what's up with that? Is there a new TGh?
>>>
>> It's in 7.3.2 table 20 in 11h draft I have here and in table 26 in
>> 11ma (unified version)
>=20
> 802.11-2007 has been published :) It's table 7-26 there as well, of
> course.
>=20
>> These numbers are being used for few years already. This is what for
>> example Cisco APs are using
>> so I have strong feeling it won't change.
>=20
> Heh yeah.
>=20
>> Not sure why you are looking for it in 11n spec
>=20
> Where did I say 11n? Huh?

It was my mistake, I was referring to 802.11s but for some reason wrote=
 n.

I looked at 802.11s Draft 2.0. It shows that these information element
IDs are all waiting ANA approval, the Mesh Configuration and Mesh ID ar=
e
shown as <ANA 33> and <ANA 34> respectively. What these numbers will
eventually be I don't know, the <ANA nn> designations are simply
sequential from the first one to the last one shown in the document, so
they may not actually end up as being sequential numbers.

Is this information of any help to you?

--=20

Brian

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

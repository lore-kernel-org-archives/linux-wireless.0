Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:48001 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab1I3MxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 08:53:03 -0400
Message-ID: <4E85BBAA.5000008@neratec.com> (sfid-20110930_145307_806358_8A34CA76)
Date: Fri, 30 Sep 2011 14:52:58 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Boris Presman <boris.presman@ti.com>,
	Assaf Azulay <assaf@ti.com>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Arun Venkataraman <arunvenk@qca.qualcomm.com>
Subject: Re: Regulatory revamp status
References: <CAB=NE6U6qmYbvHPTWGTqOdXtuxbKYbUzZXNiE6POOX9QZNRWAg@mail.gmail.com>	<1125417094.1836.1317285426615.JavaMail.root@idefix>	<CAJ-VmonqEs4mODDa2=fTj8zWHwRM7-G5e=BWNUyGdy65+kYvfg@mail.gmail.com>	<4E8468AF.8000006@neratec.com> <CAJ-VmokXUectieeOBJSMfuzzT94g7U=dqbPf-S1Oay292ur9yg@mail.gmail.com>
In-Reply-To: <CAJ-VmokXUectieeOBJSMfuzzT94g7U=dqbPf-S1Oay292ur9yg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2011 01:21 PM, Adrian Chadd wrote:
> On 29 September 2011 20:46, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> 
>> Really? Where would be 'there' countrycode-wise?
>>
>> That would definitely break today's CRDA capabilities :-\
> 
> I -think- one or both of ETSI/FCC have different CAC/NOL requirements
> for the channels which overlap the weather radars.
> At least when someone took FreeBSD to get DFS certified a while ago,
> the weather radar ranges were checked against a 30 minute CAC. :)
> 
> I think it's worth defining specific DFS parameters for each frequency
> range. That's what I'll be doing for FreeBSD when I revamp its
> net80211 regulatory database code.
> 
> 
> Adrian

I was assuming that weather radars will not be supported at all but the related channels be just disabled. It is practically impossible to assure a 99.99% detection probability (as required for ETSI 1.5.1), or? E.g. to detect ETSI radar pattern 1 (10 pulses), you basically need to treat any single detected pulse as radar event. Doable, but not very useful ;)


Zefir


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:43111 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0GAUIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 16:08:55 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
Date: Thu, 01 Jul 2010 22:11:26 +0200
MIME-Version: 1.0
Subject: Re: ATH5k - Signal measurement drops
CC: Nick Kossifidis <mickflemm@gmail.com>
Message-ID: <4C2CF66E.3933.2ADE4D@jafojtik.seznam.cz>
In-reply-to: <201006301626.57547.br1@einfach.org>
References: <4C1E6A13.4259.24AF3C@jafojtik.seznam.cz>, <4C2AEF25.1702.2DF7E2@jafojtik.seznam.cz>, <201006301626.57547.br1@einfach.org>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Randolf,

> > I have found that "fixed-b" is a right connector. There is a stupid
> > question why? When I am using "out" and not "aux". I just guess that "out"
> > should be 'a' and 'aux' should be 'b'.

> yes, i have noticed the same thing on some cards. maybe a wrong setting in 
> eeprom, or some bug in ath5k.

I hope this to be a defect of ATH5k. ATH5k cannot find proper connector automatically.
But without using debugfs, connectors cannot be switched. So I hope that it cripples
signal for many users that do not know about this peculiarity.


> > Please again have a look at:
> >   http://78.108.103.11:11080/cgi-bin/rodga_1day_big.cgi

> i have also had problems with diversity in ath5k when there is only one 
> antenna attached and in this case i always need to set a fixed antenna for 
> optimal performance.
I have no longer observe any drops in signal. Signal is pretty flat now.



> > > i guess this must be the same situation as before, no?
> i meant: did you see the same kind of drops with the older compat-wireless 
> versions, before you reported the problem?
I has been used MadWiFi before. I have moved to ATH5k because madwifi caused kernel 
to crash for more than two atheros devices and it has other strange functionality
and it is no longer supported. Last MadWiFi versions are no longer functional at all.
For example a new MadWiFi-ng cannot recognise 2nd device.

 
> > MadWiFi is much more intelligent. It tests both inputs and selects better
> > one.
> glad to hear it works for you; i had many inconsistencies with antenna 
> diversity on madwifi as well..
  For me, madwifi did 15 switches, selected better connector, ant then it 
no longer changed connector.
  But after one month of uninterrupted run, MadWiFi suddenly switched back
and signal has been dropped for unknown reason :(.


> PS: CC'ing nick, maybe he has some idea?
OK.

regards
   Jara


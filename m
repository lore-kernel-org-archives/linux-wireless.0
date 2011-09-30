Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60180 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab1I3LVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 07:21:46 -0400
Received: by vws1 with SMTP id 1so1197769vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2011 04:21:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8468AF.8000006@neratec.com>
References: <CAB=NE6U6qmYbvHPTWGTqOdXtuxbKYbUzZXNiE6POOX9QZNRWAg@mail.gmail.com>
	<1125417094.1836.1317285426615.JavaMail.root@idefix>
	<CAJ-VmonqEs4mODDa2=fTj8zWHwRM7-G5e=BWNUyGdy65+kYvfg@mail.gmail.com>
	<4E8468AF.8000006@neratec.com>
Date: Fri, 30 Sep 2011 19:21:45 +0800
Message-ID: <CAJ-VmokXUectieeOBJSMfuzzT94g7U=dqbPf-S1Oay292ur9yg@mail.gmail.com> (sfid-20110930_132154_040095_FD456869)
Subject: Re: Regulatory revamp status
From: Adrian Chadd <adrian@freebsd.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Boris Presman <boris.presman@ti.com>,
	Assaf Azulay <assaf@ti.com>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Arun Venkataraman <arunvenk@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 September 2011 20:46, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:

> Really? Where would be 'there' countrycode-wise?
>
> That would definitely break today's CRDA capabilities :-\

I -think- one or both of ETSI/FCC have different CAC/NOL requirements
for the channels which overlap the weather radars.
At least when someone took FreeBSD to get DFS certified a while ago,
the weather radar ranges were checked against a 30 minute CAC. :)

I think it's worth defining specific DFS parameters for each frequency
range. That's what I'll be doing for FreeBSD when I revamp its
net80211 regulatory database code.


Adrian

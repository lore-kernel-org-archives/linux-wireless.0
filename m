Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:50769 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab1I2Mqm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 08:46:42 -0400
Message-ID: <4E8468AF.8000006@neratec.com> (sfid-20110929_144646_082777_A4B48043)
Date: Thu, 29 Sep 2011 14:46:39 +0200
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
References: <CAB=NE6U6qmYbvHPTWGTqOdXtuxbKYbUzZXNiE6POOX9QZNRWAg@mail.gmail.com>	<1125417094.1836.1317285426615.JavaMail.root@idefix> <CAJ-VmonqEs4mODDa2=fTj8zWHwRM7-G5e=BWNUyGdy65+kYvfg@mail.gmail.com>
In-Reply-To: <CAJ-VmonqEs4mODDa2=fTj8zWHwRM7-G5e=BWNUyGdy65+kYvfg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2011 01:45 PM, Adrian Chadd wrote:
> On 29 September 2011 16:37, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> Thanks for the update.
>>
>> To me it looks not reasonable to mix in between the two approaches: either we assume countrycodes use the same DFS region for all channels, or each channel/band needs to have its own. Otherwise I feel that a DFS region bitmap would give a semi-flexible compromise that might end up being insufficient to represent some fancy countrycodes.
> 
> There's some funny stuff in there.
> 
> For example, some of the DFS bands have different CAC/NOL timing. :-)
> 
> 
> 
> Adrian

Really? Where would be 'there' countrycode-wise?

That would definitely break today's CRDA capabilities :-\


Zefir

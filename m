Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18509 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1LVQTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 11:19:30 -0500
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 3.2] iwlagn: fix (remove) use of PAGE_SIZE
Date: Thu, 22 Dec 2011 16:19:09 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE60E654C@IRSMSX102.ger.corp.intel.com> (sfid-20111222_171933_782479_164F19BC)
References: <1324332059-11630-1-git-send-email-wey-yi.w.guy@intel.com>
	<20111221161953.GB11842@tuxdriver.com>
	<1324482300.13074.295.camel@wwguy-huron>
	<20111221195821.GF11842@tuxdriver.com>
	<1324516857.4755.2.camel@wwguy-ubuntu>
 <CANUX_P2Ny7YWsYhVTHDRN03yqSdjiHvafC2utsOwdOZd1GqA3Q@mail.gmail.com>
In-Reply-To: <CANUX_P2Ny7YWsYhVTHDRN03yqSdjiHvafC2utsOwdOZd1GqA3Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >> Unless someone screams, I'd be a lot more comfortable saving this for
> >> 3.3.
> > unless Johannes has objection, I am ok for 3.3, it is not something
> > people will encounter everyday on common platform..
> >
> 
> Please note that this patch has two parts: one does the real stuff (very small),
> and the other removes unneeded DAM alignment code (big part).
> I guess it can wait to 3.3 and the small part will then be posted to stable.

Sounds like a good plan, I might need a reminder next year though :-)

FWIW, I'm not aware of anyone having run into this issue since most platforms do indeed use 4k pages.

johannes
--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052


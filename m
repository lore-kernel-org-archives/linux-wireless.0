Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:14696 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965758AbXCSHrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 03:47:39 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: wireless chipsets not supported by current wireless tree
Date: Mon, 19 Mar 2007 08:47:30 +0100
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20070316224417.792d77d6@oldman> <20070316225727.d3327d7a.rdunlap@xenotime.net>
In-Reply-To: <20070316225727.d3327d7a.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <200703190847.31321.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Is there a chance of or anyone already working on Marvell
> (non-OLPC) support, e.g., for one of these?
>
> 00:09.0 Ethernet controller: Marvell Technology Group Ltd.
> 88w8335 [Libertas] 802.11b/g Wireless (rev 03)

Yes, there is someone working there. A bunch of my patches to 
shape the OLPC driver in a way libertas_lib.ko, libertas_usb.ko, 
libertas_cs.ko got already applied. I made some experiments with 
firmware download, David Anders wrote a fwcutter and so on.

I once created a project 
http://projects.linuxtogo.org/projects/marvell8385/, but most of 
the discussion happend now in the OLPC Marvell mailing list. 
>From time to time we're also on #libertas on *.freenode.net.


Nothing works yet, and I got (and will get) distracted because my 
company switched to SAP Business One and I'm mostly busy 
extracting data out of our old system and putting that into 
SAPB1 :-(  Maybe I have again time this week.


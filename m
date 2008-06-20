Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:12614 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbYFTHLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 03:11:24 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: make mesh code configurable
Date: Fri, 20 Jun 2008 09:11:09 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200806191704.10297.hs4233@mail.mn-solutions.de> <1213889885.8967.31.camel@johannes.berg>
In-Reply-To: <1213889885.8967.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806200911.09496.hs4233@mail.mn-solutions.de> (sfid-20080620_091127_320651_6FC51916)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> you know you can build files depending on Kconfig symbols,
> right? :)

Actually I knew :-)


I'm even pondering renaming persistcfg.c to mesh.c and than move 
all mesh codelets from cmd.c, cmdresp.c, main.c etc into this 
file. The static inline thingy would then be in mesh.h. Now 
allmost all mesh stuff would be isolated.

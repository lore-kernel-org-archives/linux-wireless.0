Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21660 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbXGCPNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:13:44 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] add support for Marvell 8385 CF cards
Date: Tue, 3 Jul 2007 17:13:31 +0200
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org
References: <200707031016.18561.hs4233@mail.mn-solutions.de> <1183474524.23943.0.camel@xo-13-A4-25.localdomain>
In-Reply-To: <1183474524.23943.0.camel@xo-13-A4-25.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707031713.31610.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wireless-2.6 throught libertas-2.6, I'd say. Not for 2.6.22-rcXX.

I think it is ready for merge window of 2.6.23 and John W. 
Linville said several times that I should submit this before the 
merge window opens.

I've marked it as EXPERIMENTAL in the Kconfig. That 
nonwithstanding, I didn't change much in the code in the last 
two weeks, I'm working more on the front of scanning (and lots 
of other, non 8385-related projects).

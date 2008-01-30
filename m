Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21917 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYA3HyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 02:54:20 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH, take 3] libertas: clean up association debug messages
Date: Wed, 30 Jan 2008 08:54:38 +0100
Cc: David Woodhouse <dwmw2@infradead.org>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
References: <200710151255.56358.hs4233@mail.mn-solutions.de> <1201665912.28377.38.camel@shinybook.infradead.org>
In-Reply-To: <1201665912.28377.38.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801300854.38715.hs4233@mail.mn-solutions.de> (sfid-20080130_075425_071959_2DA1C13D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm still working through cleanups in the driver; I see you're
> sending changes directly upstream. Since upstream doesn't use
> git normally, I suspect that's going to cause lots of pain
> when it comes to merging. Any chance we could stick to the
> libertas-2.6.git tree?

I could.

I suddenly saw no activity anymore in libertas-2.6, just later I 
heard that you were in Mongolia. So I posted my stuff as before.

John, I saw that you pushed one bugfix patch upstream, but not 
the others. Please don't apply them, I'll put all ACKed patches 
into the libertas-2.6 tree instead.

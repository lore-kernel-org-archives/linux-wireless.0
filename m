Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:26871 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZJLHMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 03:12:46 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] libertas: depends on CFG80211
Date: Mon, 12 Oct 2009 09:11:24 +0200
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	linux-next@vger.kernel.org, libertas-dev@lists.infradead.org
References: <20091009190654.741eeffd.sfr@canb.auug.org.au> <20091009161730.6ae5fe59.randy.dunlap@oracle.com>
In-Reply-To: <20091009161730.6ae5fe59.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910120911.24781.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> libertas uses CFG80211 functions so it should depend on that 
symbol.

Ack.


Sigh, I should concentrate more on getting clean patches on the 
first iteration.

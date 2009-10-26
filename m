Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:15783 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbZJZIEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 04:04:40 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for libertas+cfg80211
Date: Mon, 26 Oct 2009 09:04:12 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <20091022133043.185554096@mail.mn-solutions.de> <1256315415.2164.46.camel@localhost.localdomain> <20091025033853.GA25873@infradead.org>
In-Reply-To: <20091025033853.GA25873@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910260904.12417.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> How much does mesh actually get used?  AFAICS it's a
> OLPC-specific one off.

A good question, I don't know no-one that uses mesh outside of 
OLPC.


> So unless OLPC people come up and fix it why do people even
> bother with it? 

In some way the OLPC people won't be bothered, they don't
follow linux-git or linux-wireless, they are stuck to some
old kernel (2.6.25 AFAIK). So they don't even notice :-)

However, they need MESH, so if I now rip MESH out completely
just because I change some configuration API, that would
bring more burden to them.

-- 
http://www.holgerschurig.de

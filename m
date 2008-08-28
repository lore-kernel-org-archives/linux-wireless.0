Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:11805 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYH1JMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:12:14 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] wireless/libertas/if_cs.c: fix memory leaks
Date: Thu, 28 Aug 2008 11:12:03 +0200
Cc: Adrian Bunk <bunk@kernel.org>, dcbw@redhat.com,
	linville@tuxdriver.com, libertas-dev@lists.infradead.org,
	netdev@vger.kernel.org
References: <20080827220508.GQ11734@cs181140183.pp.htv.fi>
In-Reply-To: <20080827220508.GQ11734@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808281112.04312.hs4233@mail.mn-solutions.de> (sfid-20080828_111217_836813_988E3004)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It looks a bit as if not freeing "fw" in if_cs_prog_real() was
> done intentionally, but I'm not seeing why it shouldn't be
> freed.

No, it wasn't made intentionally, thanks for finding out.

Acked-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5326 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbXLJQXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:23:13 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH 07/48] libertas: make more functions static
Date: Mon, 10 Dec 2007 17:23:53 +0100
Cc: Arnd Bergmann <arnd@arndb.de>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	John Linville <linville@tuxdriver.com>
References: <E1J1kpB-0006kg-FH@shinybook.infradead.org> <200712101708.32668.arnd@arndb.de>
In-Reply-To: <200712101708.32668.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712101723.53678.hs4233@mail.mn-solutions.de> (sfid-20071210_162317_780110_67A29577)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> * Better, avoid forward declarations entirely by
> ordering the functions in the way they are called.

Right.

I wanted to keep the patch small, as I knew that David might 
create patches in the same area.

But libertas can easily take another 200 cleanup-patches ... :-)

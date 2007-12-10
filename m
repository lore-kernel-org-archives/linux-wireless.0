Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36775 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbXLJQ3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:29:48 -0500
Subject: Re: [PATCH 07/48] libertas: make more functions static
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200712101723.53678.hs4233@mail.mn-solutions.de>
References: <E1J1kpB-0006kg-FH@shinybook.infradead.org>
	 <200712101708.32668.arnd@arndb.de>
	 <200712101723.53678.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 11:30:10 -0500
Message-Id: <1197304210.2957.54.camel@shinybook.infradead.org> (sfid-20071210_162952_430139_BAE60EB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-10 at 17:23 +0100, Holger Schurig wrote:
> > * Better, avoid forward declarations entirely by
> > ordering the functions in the way they are called.
> 
> Right.
> 
> I wanted to keep the patch small, as I knew that David might 
> create patches in the same area.

The whole command queueing stuff is my primary focus... I just had to
clean it all up a bit before I could really get on with that.

This function will be the subject of another commit with 'kill' in the
title, fairly soon now...

Although I suspect that given the title of Holger's commit, he actually
meant to make it static. It really is only used in that one file.

-- 
dwmw2


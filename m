Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27980 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbXLJQAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:00:36 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH 14/48] libertas: fix data packet size errors
Date: Mon, 10 Dec 2007 17:01:16 +0100
Cc: Michael Buesch <mb@bu3sch.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <E1J1kpI-0006lF-Pz@shinybook.infradead.org> <200712101649.39391.mb@bu3sch.de>
In-Reply-To: <200712101649.39391.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712101701.16247.hs4233@mail.mn-solutions.de> (sfid-20071210_160105_023773_CF4EC952)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Whoops, something's wrong here.
> You are subtracting from a LE value.

You're right. Sparse detected that and I later sent a patch that 
fixed it. See Patch 21/48.

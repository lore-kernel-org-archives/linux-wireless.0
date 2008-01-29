Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7429 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYA2H1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 02:27:06 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: misc cleanups in compact-flash code
Date: Tue, 29 Jan 2008 08:27:17 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200801281724.21321.hs4233@mail.mn-solutions.de> <1201538194.14441.2.camel@localhost.localdomain>
In-Reply-To: <1201538194.14441.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801290827.18032.hs4233@mail.mn-solutions.de> (sfid-20080129_072710_784451_49B052FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This seems kind of pointless; card is a local variable and
> isn't used anywhere after this.

Okay. I put this code in (without too much thinking) when I
chased the IRQ-at-card-removal error.

Drop the patch. When I change something else in if_cs.c, I'll
remove the TODO strings.

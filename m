Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYHMO0O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 10:26:14 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: Pondering: how to improve mac80211 roaming ...
Date: Wed, 13 Aug 2008 16:26:11 +0200
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <200808131426.55673.hschaa@suse.de> <200808131618.13141.hs4233@mail.mn-solutions.de>
In-Reply-To: <200808131618.13141.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808131626.11263.hschaa@suse.de> (sfid-20080813_162619_517148_EE62A44C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 13. August 2008 16:18:13 schrieb Holger Schurig:
> > It might even be beneficial to cancel a currently active
> > background scan once the TX queue is filling up and report the
> > already gathered information to the user space.
>
> This brings policy into the kernel. Why should TX data be more
> important than a scan result?

I was only referring to background scanning not triggered by the user
space. If any user space application requests a scan it may of course
not be canceled due to TX data.

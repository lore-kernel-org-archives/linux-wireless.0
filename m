Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38144 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbYG1SR2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 14:17:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFC/RFT] b43: Rewrite TX power adjustment
Date: Mon, 28 Jul 2008 20:17:04 +0200
Cc: linux-wireless@vger.kernel.org
References: <200807261726.53279.mb@bu3sch.de>
In-Reply-To: <200807261726.53279.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807282017.04979.mb@bu3sch.de> (sfid-20080728_201732_182985_D6C030CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 July 2008 17:26:52 Michael Buesch wrote:
> This is an experimental attempt for fixing the currently-not-so-good
> TX power adjustment.

Hm, is anybody going to test this, or are there really no transmission
problems left? :)

But please note that current wireless-testing tree seems to have some
unrelated TX issues in mac80211 (see the discussions about the qdisc
and skb->cb stuff.)

In any case, I'd like to have some initial testing of this patch? :)
I think it really is a good step forward, once all bugs in it are fixed.

-- 
Greetings Michael.

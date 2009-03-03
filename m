Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46276 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZCCNfP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 08:35:15 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Pass more RX flags to mac80211
Date: Tue, 3 Mar 2009 14:34:45 +0100
Cc: Bo Han <hanbo00@gmail.com>, linux-wireless@vger.kernel.org
References: <200903022318.37977.mb@bu3sch.de> <d0ad1e930903030527u27c13defp15db0e253d68a580@mail.gmail.com>
In-Reply-To: <d0ad1e930903030527u27c13defp15db0e253d68a580@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903031434.45359.mb@bu3sch.de> (sfid-20090303_143519_408651_177EC9A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 March 2009 14:27:30 Bo Han wrote:
> Hi Michael,
> 
> After I applied the patch you provided below, the system is still frozen
> after I turn on the fcsfail flag.  If it is possible, could you please test
> on your systems?

The patch is not supposed to fix your freezes. Please remove your patches and fix the freeze yourself.

-- 
Greetings, Michael.

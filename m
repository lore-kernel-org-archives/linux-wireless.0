Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38653
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbYAVMjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 07:39:15 -0500
Date: Tue, 22 Jan 2008 04:39:22 -0800 (PST)
Message-Id: <20080122.043922.217671583.davem@davemloft.net> (sfid-20080122_123919_548905_B2D7898F)
To: hs4233@mail.mn-solutions.de
Cc: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6
 (2008-01-21)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200801221253.40347.hs4233@mail.mn-solutions.de>
References: <200801220856.55024.hs4233@mail.mn-solutions.de>
	<20080122.022437.07454007.davem@davemloft.net>
	<200801221253.40347.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 22 Jan 2008 12:53:40 +0100

> > What I usually expect, when it isn't clear, is that the first
> > "Signed-off-by:" I see is what I use at the author.
> 
> Hmm, then the fault doesn't seem to be on my side.
> 
> $ git show commit 0196c6a4aec1e420a6bd0b420ff1768fec059d4d
> 
> (on the wireless-2.6/everything tree) shows:
> 
>     Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
>     Acked-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Right.

I suspect John used the standard GIT email patch applying
scripts which uses the From: as the patch author by default.

That, among other reasons, is why I apply patches manually
and don't use the automated scripts.


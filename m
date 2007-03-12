Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:54430 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964919AbXCLD3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 23:29:08 -0400
Message-ID: <45F4C902.9050405@lwfinger.net>
Date: Sun, 11 Mar 2007 22:29:06 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFT] [PATCH] bcm43xx: ACI fixes
References: <20070312010420.353a59c0@localhost>
In-Reply-To: <20070312010420.353a59c0@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> Please test the following patch. It syncs ACI (Adjacent Channels
> Interference) code to specs. I can't test it right now. Will port to
> mac80211 branch ASAP.
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> ----

NACK - this patch really kills performance on my 4311. I'll see if I can find the problem.

Larry


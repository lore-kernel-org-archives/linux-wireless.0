Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:56760 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875AbXCLU2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 16:28:55 -0400
Message-ID: <45F5B805.8040401@lwfinger.net>
Date: Mon, 12 Mar 2007 15:28:53 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [RFT] [PATCH] bcm43xx: ACI fixes
References: <20070312010420.353a59c0@localhost>	<45F4C902.9050405@lwfinger.net>	<45F4EA57.5010405@lwfinger.net> <20070312070558.07488359@localhost>
In-Reply-To: <20070312070558.07488359@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> On Mon, 12 Mar 2007 00:51:19 -0500
> 
> Well, wait. I'd want to see some performance improvements before the patch
> is applied. That's why I didn't send it to John and put RFT in the
> subject. Are there any?

No, I don't see any significant difference in RX or TX throughput with this patch. So far, I have
only tested on the 4311. Results for the 4306 and 4318 will come later.

Larry


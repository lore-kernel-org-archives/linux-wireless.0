Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53218
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbXCLUyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 16:54:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFT] [PATCH] bcm43xx: ACI fixes
Date: Mon, 12 Mar 2007 21:53:34 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <20070312010420.353a59c0@localhost> <20070312070558.07488359@localhost> <45F5B805.8040401@lwfinger.net>
In-Reply-To: <45F5B805.8040401@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703122153.34684.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 March 2007 21:28, Larry Finger wrote:
> Stefano Brivio wrote:
> > On Mon, 12 Mar 2007 00:51:19 -0500
> > 
> > Well, wait. I'd want to see some performance improvements before the patch
> > is applied. That's why I didn't send it to John and put RFT in the
> > subject. Are there any?
> 
> No, I don't see any significant difference in RX or TX throughput with this patch. So far, I have
> only tested on the 4311. Results for the 4306 and 4318 will come later.

Not that interference mitigation can not improve the signal,
if there is no interference disturbing it. ;) It _is_ already
best possible signal, then.

-- 
Greetings Michael.

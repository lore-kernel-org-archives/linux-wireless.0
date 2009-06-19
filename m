Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2996 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZFSLKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 07:10:19 -0400
Date: Fri, 19 Jun 2009 07:08:53 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-pm@lists.linux-foundation.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@venema.h4ckr.net, linux-pci@vger.kernel.org
Subject: Re: [ath5k-devel] [linux-pm] PCI hotplug v.s. suspend
Message-ID: <20090619110853.GA18956@hash.localnet>
References: <Pine.LNX.4.44L0.0906181437090.3129-100000@netrider.rowland.org> <4A3AAF0A.9020707@tuffmail.co.uk> <4A3B4D8C.6010002@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A3B4D8C.6010002@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 09:34:20AM +0100, Alan Jenkins wrote:
> I tried an earlier version without the problem workaround.  Bob's
> suggested patch to remove the free_irq() on suspend works fine.  It
> fixes the WARNING when the device is removed during suspend, and it
> still works if the device is not removed during suspend.

Okay thanks for finding it and testing.  I'll send a version with my
s-o-b later today.

-- 
Bob Copeland %% www.bobcopeland.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:44339 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYLJQNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 11:13:06 -0500
Date: Wed, 10 Dec 2008 16:12:59 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	hmh@hmh.eng.br
Subject: Re: [RFC] b43: rework rfkill code
Message-ID: <20081210161259.GA12069@srcf.ucam.org> (sfid-20081210_171311_474472_B6EAD065)
References: <20081210150935.GA10927@srcf.ucam.org> <200812101648.30161.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200812101648.30161.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 10, 2008 at 04:48:29PM +0100, Michael Buesch wrote:
> On Wednesday 10 December 2008 16:09:35 Matthew Garrett wrote:
> > I've reworked the rfkill code in b43. This ought to be more consistent 
> ...
> 
> I'm fine with this, as long as you take over the responsibility for the whole b43-rfkill code.
> I'm not going to touch it anymore. I'm only going to fix it by either forwarding bugreports
> to somebody else (you, in that case) or by reverting patches until it starts working again.

Works for me, though I'd appreciate it if people could give it a quick 
sanity test. The main thing I'm worried about is LED control, which I 
think /ought/ to still work but is dependent on everything in the rfkill 
core working properly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

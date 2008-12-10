Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42875 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357AbYLJVdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 16:33:39 -0500
Date: Wed, 10 Dec 2008 19:33:34 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC] b43: rework rfkill code
Message-ID: <20081210213334.GA7589@khazad-dum.debian.net> (sfid-20081210_223344_305330_EE710E0C)
References: <20081210150935.GA10927@srcf.ucam.org> <1228922997.15837.6.camel@johannes.berg> <1228927898.19553.164.camel@violet.holtmann.net> <1228929529.15837.34.camel@johannes.berg> <1228929820.15837.40.camel@johannes.berg> <1228930083.15837.44.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228930083.15837.44.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 10 Dec 2008, Johannes Berg wrote:
> On Wed, 2008-12-10 at 18:23 +0100, Johannes Berg wrote:
> > Then there's user_claim_unsupported which is set by all drivers but
> > rt2x00, probably because they have hardware kill switches and thus they
> > have to set it even if it's not strictly true, because of the lacking
> > separation between these things (that I pointed out)
> 
> IOW, correct me if I'm wrong, it seems to me that user_claim_unsupported
> really is a wrong name for "has hw kill", which could be avoided if sw

I never understood what user_claim_unsupported is for.  I left it alone
because of that, but it looks like some artifact of the old rfkill that did
horrible things to the input layer.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

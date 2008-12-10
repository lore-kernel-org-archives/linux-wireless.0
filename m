Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55896 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbYLJPsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 10:48:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC] b43: rework rfkill code
Date: Wed, 10 Dec 2008 16:48:29 +0100
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, hmh@hmh.eng.br
References: <20081210150935.GA10927@srcf.ucam.org>
In-Reply-To: <20081210150935.GA10927@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812101648.30161.mb@bu3sch.de> (sfid-20081210_164858_967946_748F4744)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008 16:09:35 Matthew Garrett wrote:
> I've reworked the rfkill code in b43. This ought to be more consistent 
...

I'm fine with this, as long as you take over the responsibility for the whole b43-rfkill code.
I'm not going to touch it anymore. I'm only going to fix it by either forwarding bugreports
to somebody else (you, in that case) or by reverting patches until it starts working again.

-- 
Greetings, Michael.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:47635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYE3WtA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 18:49:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend vs. b43
Date: Sat, 31 May 2008 00:49:41 +0200
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1212150713.4117.2.camel@johannes.berg> <200805302319.34173.rjw@sisk.pl> <1212187090.20421.2.camel@johannes.berg>
In-Reply-To: <1212187090.20421.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805310049.41782.rjw@sisk.pl> (sfid-20080531_004903_171787_A6633FF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, 31 of May 2008, Johannes Berg wrote:
> 
> > It hangs for me either at read_unlock_irqrestore() in b43_op_tx() or somewhere
> > in ieee80211_tx() (at various places).
> 
> Huh. Why is it even getting into the tx path? And even then, why does it
> hang at an unlock?

Well, I saw that during hibernation, so it probably happened after creating the
image, when devices were being resumed for image saving.

Thanks,
Rafael

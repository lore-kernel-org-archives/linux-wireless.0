Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:23035 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760333AbXFAVxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 17:53:51 -0400
Received: by ug-out-1314.google.com with SMTP id j3so320448ugf
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2007 14:53:50 -0700 (PDT)
Message-ID: <7b4bf7ff0706011453h518f1f79v771529b768d9e975@mail.gmail.com>
Date: Fri, 1 Jun 2007 23:53:49 +0200
From: "Olivier Cornu" <o.cornu@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706012342.20592.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200706011129.12432.mb@bu3sch.de> <200706012242.52226.mb@bu3sch.de>
	 <7b4bf7ff0706011400g3d03afb6n18106773f18fade6@mail.gmail.com>
	 <200706012342.20592.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/6/1, Michael Buesch <mb@bu3sch.de>:
> On Friday 01 June 2007 23:00:16 Olivier Cornu wrote:
> > 2007/6/1, Michael Buesch <mb@bu3sch.de>:
> > > On Friday 01 June 2007 13:55:31 Olivier Cornu wrote:
> > > > Unless i missed something, stop_queue() isn't called outside of the tx
> > > > handler in bcm43xx code...
> > >
> > > You missed something.
> >
> > The only call to ieee80211_stop_queue() grep can find is in
> > bcm43xx_dma.c:1171, i.e. bcm43xx_dma_tx(). And bcm43xx_dma_tx() is
> > only called from bcm43xx_tx().
> > What did i miss?
>
> Periodic work. I removed that in my current tree.

I only have the wireless-dev tree, that must be why... ;)

--
Olivier Cornu

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:41552 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbYLJRkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:40:05 -0500
Received: by ewy10 with SMTP id 10so878182ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 09:40:03 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rfkill: strip pointless notifier chain
Date: Wed, 10 Dec 2008 18:40:00 +0100
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1228927728.15837.10.camel@johannes.berg> <200812101801.35735.IvDoorn@gmail.com> <1228929609.15837.36.camel@johannes.berg>
In-Reply-To: <1228929609.15837.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200812101840.00480.IvDoorn@gmail.com> (sfid-20081210_184011_320138_B6C81248)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008, Johannes Berg wrote:
> On Wed, 2008-12-10 at 18:01 +0100, Ivo van Doorn wrote:
> > On Wednesday 10 December 2008, Johannes Berg wrote:
> > > No users, so no reason to have it.
> > 
> > Henrique, you introduced the notifier chain, are there any upcoming
> > users for it or can it indeed be removed?
> 
> It can be added back with the users when needed.

Fine, but I was more thinking about how soon would such an upcoming
user arrive. There is no point in deleting the interface when it will
be added within a couple of days.

Anyway, I'll add my ack to the patch.

Ivo

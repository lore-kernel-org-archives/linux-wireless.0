Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47463 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab0KPRBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 12:01:41 -0500
Received: by eye27 with SMTP id 27so434813eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 09:01:39 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
Date: Tue, 16 Nov 2010 18:00:35 +0100
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, jay_hung@ralinktech.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131911.47346.IvDoorn@gmail.com> <201011161742.08503.helmut.schaa@googlemail.com> <20101116165302.GA29570@sig21.net>
In-Reply-To: <20101116165302.GA29570@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011161800.40654.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 16 November 2010 schrieb Johannes Stezenbach:
> On Tue, Nov 16, 2010 at 05:42:08PM +0100, Helmut Schaa wrote:
> > Am Dienstag 16 November 2010 schrieb Johannes Stezenbach:
> > > 
> > > Hm, yes, rt2x00mac_conf_tx() has the same issue that it calls
> > > rt2x00queue_get_queue() with an argument which is a mac80211 AC,
> > > but expects an enum data_queue_qid.  So one could says one
> > > bug cancels the other out.
> > 
> > Right. We could of course add a mac80211-queue <-> rt2x00-queue mapping in
> > the appropriate places or rename the QID_* identifiers accordingly. Not sure
> > if it's worth it ...
> 
> Hm, reducing confusion enhances maintainability.

I fully agree. I just meant that there are more severe issues in rt2x00 I plan
to work on. But feel free to send a patch :)

Helmut

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27339 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab0BYLHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 06:07:12 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 03:07:12 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19334.24140.564616.316014@gargle.gargle.HOWL>
Date: Thu, 25 Feb 2010 16:56:04 +0530
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH] ath9k_htc: sync add_interface and remove_interface with
 mac80211
In-Reply-To: <201002251154.30917.helmut.schaa@googlemail.com>
References: <201002241633.47090.helmut.schaa@googlemail.com>
	<43e72e891002240918i152253c9o8130dc507d2dc03@mail.gmail.com>
	<201002251154.30917.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa wrote:
> Am Mittwoch 24 Februar 2010 schrieb Luis R. Rodriguez:
> > Thanks! Applied and pushed out. I should note, since no one else has,
> > that ath9k_htc has gotten a huge face lift by now. Unfortunately the
> > entire new revamp was done through an internal private tree but from
> > what I gather submission upstream should happen soon.
> 
> Does it make much sense then to hack on the driver right now?
> Should linux-wireless be CC'ed as well for ath9k_htc patches?

We would be making a submission soon, as soon as a few
internal tests are run.

I would think that holding off work on the public ath9k_htc tree would be good.
Patches are always welcome for the driver after the submission. :)

Sujith

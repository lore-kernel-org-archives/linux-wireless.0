Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36140 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759168Ab0BYKyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 05:54:40 -0500
Received: by bwz1 with SMTP id 1so2691961bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 02:54:38 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] ath9k_htc: sync add_interface and remove_interface with mac80211
Date: Thu, 25 Feb 2010 11:54:30 +0100
Cc: devel@linuxdriverproject.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
References: <201002241633.47090.helmut.schaa@googlemail.com> <43e72e891002240918i152253c9o8130dc507d2dc03@mail.gmail.com>
In-Reply-To: <43e72e891002240918i152253c9o8130dc507d2dc03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201002251154.30917.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 24 Februar 2010 schrieb Luis R. Rodriguez:
> Thanks! Applied and pushed out. I should note, since no one else has,
> that ath9k_htc has gotten a huge face lift by now. Unfortunately the
> entire new revamp was done through an internal private tree but from
> what I gather submission upstream should happen soon.

Does it make much sense then to hack on the driver right now?
Should linux-wireless be CC'ed as well for ath9k_htc patches?

Thanks,
Helmut

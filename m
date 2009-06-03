Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54444 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbZFCEKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 00:10:31 -0400
Date: Wed, 3 Jun 2009 01:10:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090603041030.GB10464@khazad-dum.debian.net>
References: <4A238EA2.4040106@tuffmail.co.uk> <1243858256.5299.14.camel@johannes.local> <1243867620.3015.17.camel@localhost.localdomain> <4A23FD91.8020200@tuffmail.co.uk> <1243885494.3015.29.camel@localhost.localdomain> <4A24559D.7010201@tuffmail.co.uk> <1243928308.3192.38.camel@localhost.localdomain> <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk> <1243932109.3192.73.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243932109.3192.73.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 02 Jun 2009, Marcel Holtmann wrote:
> Forget about this EPO crap. That is just a stupid concept anyway.

Is it?  So, if I use the _hardware switch_ on my laptop to kill all
internal radios, it shouldn't be enforced by the OS on extra radios I
plugged?  Or on shitty internal WLAN cards that doesn't tie properly to
the mini-pci and mini-pcie hardware kill lines?

And any userspace PoS program can decide to bring up such radios that
are not hardware-killed even if I am clearly trying to disable them all?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

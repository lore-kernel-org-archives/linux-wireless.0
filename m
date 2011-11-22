Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35595 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab1KVOPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 09:15:30 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1RSr8B-0007s9-Uh
	for linux-wireless@vger.kernel.org; Tue, 22 Nov 2011 09:15:28 -0500
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id pAME5IH4014817
	for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 09:05:18 -0500
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id pAME5HXn014774
	for linux-wireless@vger.kernel.org; Tue, 22 Nov 2011 09:05:17 -0500
Date: Tue, 22 Nov 2011 09:05:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless regressions Re: 3.2-rc2+: Reported regressions from 3.0 and
 3.1
Message-ID: <20111122140516.GB8452@tuxdriver.com> (sfid-20111122_151538_970240_6347E344)
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
 <201111212249.31196.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201111212249.31196.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ones that look specific to wireless (or bluetooth)...

On Mon, Nov 21, 2011 at 10:49:30PM +0100, Rafael J. Wysocki wrote:
 
> Subject    : iwlagn is getting very shaky
> Submitter  : Norbert Preining <preining@logic.at>
> Date       : 2011-10-19 6:01
> Message-ID : 20111019060108.GA11588@gamma.logic.tuwien.ac.at
> References : http://marc.info/?l=linux-kernel&m=131914553920614&w=2

> Subject    : 3.1+ iwlwifi lockup
> Submitter  : Dave Jones <davej@redhat.com>
> Date       : 2011-10-31 14:34
> Message-ID : 20111031143408.GA17152@redhat.com
> References : http://marc.info/?l=linux-kernel&m=132007169420160&w=2

> Subject    : Oops on suspend with libertas SDIO (Linux 3.2-rc2)
> Submitter  : Sven Neumann <s.neumann@raumfeld.com>
> Date       : 2011-11-17 15:36
> Message-ID : 1321544210.31090.6.camel@sven
> References : http://marc.info/?l=linux-kernel&m=132154527715807&w=2

> Subject    : [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth: Increase HCI reset timeout ...)
> Submitter  : Tomáš Janoušek <tomi@nomi.cz>
> Date       : 2011-11-18 18:40
> Message-ID : 20111118184017.GA5052@nomi.cz
> References : http://marc.info/?l=linux-kernel&m=132164169511416&w=2

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:16576 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbbKGHiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2015 02:38:23 -0500
From: Julien Cubizolles <j.cubizolles@free.fr>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: mwifiex problem: incompatible network settings
References: <87wpu9632c.fsf@free.fr> <1445875814.31216.18.camel@redhat.com>
	<87twpd8fk4.fsf@free.fr> <1445972115005.99995@marvell.com>
	<87a8r4ugth.fsf@free.fr> <1446043853.24757.51.camel@redhat.com>
	<87vb9qsmg1.fsf@free.fr>
	<b2db7a93638f44b683aef052ca442c5c@SC-EXCH04.marvell.com>
	<87r3k5h161.fsf@free.fr>
	<cffeead80528479fbe6883776d115208@SC-EXCH04.marvell.com>
Date: Sat, 07 Nov 2015 08:38:18 +0100
Message-ID: <878u6aqmxh.fsf@free.fr> (sfid-20151107_083844_545538_4AD1A0D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:


> Thanks for the logs. We found one bug in our code. We expect vendor
> specific IE at the beginning of IE buffer otherwise connection is
> rejected.
> We will prepare a fix and get back.

Thanks a lot for making my laptop usable again. I'll be happy to test
the fix when it's ready.

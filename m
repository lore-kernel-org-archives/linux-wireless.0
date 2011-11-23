Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.4.202.46.78.clients.your-server.de ([78.46.202.4]:36679
	"EHLO alpha-unix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262Ab1KWGd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 01:33:27 -0500
Message-ID: <4ECC91D9.7030902@alpha-unix.de> (sfid-20111123_073331_026128_C7CB1B06)
Date: Wed, 23 Nov 2011 07:25:29 +0100
From: Michael Basse <michael@alpha-unix.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
References: <20111116100915.GA2191@redhat.com> <4ECC071E.5050403@alpha-unix.de> <1700561.mj30bDeLIf@helmutmobil.site>
In-Reply-To: <1700561.mj30bDeLIf@helmutmobil.site>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 22.11.2011 23:10, schrieb Helmut Schaa:
> Why do you think the panics are produced by rt2800pci? The stacktraces
> attached to https://bugs.launchpad.net/ubuntu/+source/linux/+bug/869502
> don't show rt2x00 related functions ...
> 
> Helmut

Hi Helmut,
i am not sure if the panics are related to rt2800pci. Because of the
following facts i thought it was related to that module.

- all systems facing that kind of panics are using rt2800pci
- with the newest compat wifi-drivers that kind of panics are gone
- panics are not happening when wifi is disabled (using fn-key to
disable wifi)
- i saw the patch from Stanislaw and thought it will fix the issue
because its related to rt2800pci

My problem is that i dont know how to do a better debbuging for that
kind of problem, so i was just trying some things around and thought the
issues are coming from rt2800pci. But all i am doing at the moment is
just guessing, because i am lost with that kind of problem.


Greetings

Michael




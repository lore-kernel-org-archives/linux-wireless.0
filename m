Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:41190 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756283AbXLLI4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 03:56:46 -0500
Date: Wed, 12 Dec 2007 08:56:44 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dcbw@redhat.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071211171106.ec6f6d38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <788286.65300.qm@web52901.mail.re2.yahoo.com> (sfid-20071212_085650_015317_6F62A8A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> It might be interesting to see what value of `i' is causing it to fall over.

I tried unrolling the loop, but a single byte read for i = 0 is enough to lock things up.

> Did any earlier version of the 2.6 kernel work OK?

Unfortunately, I don't know. I swapped this card out of the old 2.4.x machine into a machine
already running Fedora 7. The card works when I put it back into the 2.4 machine too, so it's not
a hardware problem with the card.

So I suppose the next step would be trying a linux 2.6.0 kernel? Or was hostap included in the
kernel later than that?

Cheers,
Chris




      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/

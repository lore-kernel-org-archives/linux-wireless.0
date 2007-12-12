Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:36646 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758140AbXLLKW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 05:22:26 -0500
Date: Wed, 12 Dec 2007 10:22:25 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dcbw@redhat.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071212020325.96dbf41b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <293380.40997.qm@web52902.mail.re2.yahoo.com> (sfid-20071212_102230_038411_4510BB89)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> hm.  Could be some platform thing.  Strange.  It might be worth checking
> around that ioremap, make sure that the value which it returned is the one
> which is being used in the function-which-hangs, etc.

OK, not difficult to try. (This is x86, BTW.) But I'm still baffled as to precisely why it is
hanging. Is it waiting for a value from the PCI bus that never appears, or something? Are there
any other PCI-related tests that I can do to check that the device has been initialised correctly
on the bus, please?

> hostap_plx.c first appeared in 2.6.14.

OK, I can build one of those kernels. Before then, I think that hostap was provided as an external
source package.

Cheers,
Chris


      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com


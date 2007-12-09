Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52903.mail.re2.yahoo.com ([206.190.49.13]:39376 "HELO
	web52903.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751584AbXLIWNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 17:13:10 -0500
Date: Sun, 9 Dec 2007 22:13:09 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Dan Williams <dcbw@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071209230652.7156fe17@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <248113.29149.qm@web52903.mail.re2.yahoo.com> (sfid-20071209_221314_668780_B484DA17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Stefano Brivio <stefano.brivio@polimi.it> wrote:
> Not a fix, but if you load the module with ignore_cis = 1, it should work.

Well, if the I/O memory mapping is broken then wouldn't that just move the problem down to the
next attempt to access it?

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:54558 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751616AbXLIXpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 18:45:52 -0500
Date: Mon, 10 Dec 2007 00:42:11 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
Message-ID: <20071210004211.145487b7@morte> (sfid-20071209_234556_979119_9BE983CC)
In-Reply-To: <248113.29149.qm@web52903.mail.re2.yahoo.com>
References: <20071209230652.7156fe17@morte>
	<248113.29149.qm@web52903.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 9 Dec 2007 22:13:09 +0000 (GMT)
Chris Rankin <rankincj@yahoo.com> wrote:

> --- Stefano Brivio <stefano.brivio@polimi.it> wrote:
> > Not a fix, but if you load the module with ignore_cis = 1, it should work.
> 
> Well, if the I/O memory mapping is broken then wouldn't that just move the
> problem down to the next attempt to access it?

Dunno but this helped in a similar crash I had some months ago, IIRC.


-- 
Ciao
Stefano

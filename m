Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:50467 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145AbYGGWBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 18:01:50 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Tue, 8 Jul 2008 00:01:48 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de> <200807072327.17714.stefan-a-bauer@gmx.net> <200807072344.07580.IvDoorn@gmail.com>
In-Reply-To: <200807072344.07580.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807080001.48480.stefan.bauer@cs.tu-chemnitz.de> (sfid-20080708_000230_655887_0ADE25E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 7. Juli 2008 schrieb Ivo van Doorn:

> What happens when you compile ecb and arc4 into the kernel
> instead as seperate modules?

Then it works. Thanks a lot. The new .config can be found here:
<http://www-user.tu-chemnitz.de/~stefb/rt2500pci/config_works>

But I think it's a bug, nevertheless. If there are any patches to test I'll 
give them a try.


Regards, Stefan

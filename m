Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:60671 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab1EMRkn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 13:40:43 -0400
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <i@lri.fr>)
	id 1QKwLy-0004Ly-4H
	for linux-wireless@vger.kernel.org; Fri, 13 May 2011 19:40:42 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QKwLx-0001XB-41
	for linux-wireless@vger.kernel.org; Fri, 13 May 2011 19:40:41 +0200
Date: Fri, 13 May 2011 19:40:41 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: Re: WPA in ad-hoc mode with carl9170
Message-ID: <20110513174041.GA4690@zenon.in.qult.net> (sfid-20110513_194046_598414_49A2975A)
References: <20110513160113.GA14293@zenon.in.qult.net>
 <BANLkTikiWNXnB6NcS48-1x9KYes_o=omjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTikiWNXnB6NcS48-1x9KYes_o=omjg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 12:39:53PM -0400, thus spake Brian Prodoehl:
> Have you tested only with hw crypto?  Try passing the nohwcrypt param
> to the module while loading.

I just tried that and at first it seemed to make no difference.  But at some
point, one of the two nodes of my testbed started to send encrypted frames
(both broadcast and unicast) and the other node could receive them okay.

Unfortunately, I just can't make the other node work (the difference being it
is a x86_64 netbook vs. an i386 embedded atom industrial PC for the first
node).

Next week, I'll hopefully have more time to investigate and find a repeatable
procedure to make that work or break.  My preliminary tests show that setting
the nohwcrypt option makes no difference.

Thanks for the hint anyway.

Ignacy

-- 
A person is shit's way of making more shit.
		-- S. Barnett, anthropologist.

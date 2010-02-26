Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34586 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965876Ab0BZT7S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 14:59:18 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA errors
Date: Fri, 26 Feb 2010 20:59:01 +0100
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <4B881C70.9030004@lwfinger.net>
In-Reply-To: <4B881C70.9030004@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002262059.02383.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 February 2010 20:09:36 Larry Finger wrote:
> On 02/26/2010 12:34 PM, Linus Torvalds wrote:
> > 
> > This makes the b43 driver just automatically fall back to PIO mode when 
> > DMA doesn't work.
> > 
> > The driver already told the user to do it, so rather than have the user 
> > reload the module with a new flag, just make the driver do it 
> > automatically. We keep the message as an indication that something is 
> > wrong, but now just automatically fall back to the hopefully working PIO 
> > case.
> > 
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---

Where is that patch? I can't find it in any list archives.

-- 
Greetings, Michael.

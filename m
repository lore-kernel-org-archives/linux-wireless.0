Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41516
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXCWU2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:28:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: jt@hpl.hp.com
Subject: Re: [stable] [PATCH] fix information leak in wireless extensions on 64-bit platforms
Date: Fri, 23 Mar 2007 21:27:17 +0100
Cc: Chris Wright <chrisw@sous-sol.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
References: <1174640787.3588.65.camel@johannes.berg> <20070323193643.GY10574@sequoia.sous-sol.org> <20070323200037.GA5165@bougret.hpl.hp.com>
In-Reply-To: <20070323200037.GA5165@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703232127.17790.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 March 2007 21:00, Jean Tourrilhes wrote:
> On Fri, Mar 23, 2007 at 12:36:43PM -0700, Chris Wright wrote:
> > * Jean Tourrilhes (jt@hpl.hp.com) wrote:
> > 
> > > 	The last thing is that I could not test those stuff myself,
> > > and the testing done for me was limited. I would be more confident if
> > > you were to give it a good beating before we push that into stable,
> > > because you know what to test.
> > 
> > That's useful info.  Have you had any luck (it looks pretty straight
> > forward)?
> 
> 	Let's be more clear. I tested properly on 32 bits. But, 32
> bits is not where there is issue, this issue is specific to 64 bits. I
> don't have a 64 bits platfor. It seems that few people doing wireless
> have access to 64 bits platform (actually, it seems most of them don't
> have access to SMP either), otherwise this would have been found many
> years ago.
> 	Johannes is one of the few having access to 64 bits stuff.

I finally have an USB ZD stick now, too. So I can test stuff, too.
Should I test this somehow?

-- 
Greetings Michael.

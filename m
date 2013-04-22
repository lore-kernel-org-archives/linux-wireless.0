Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3DVN76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:59:58 -0400
Message-ID: <1366639194.8637.19.camel@jlt4.sipsolutions.net> (sfid-20130422_160000_456872_9EFBCCC1)
Subject: Re: [PATCHv2] iw: Deocde some more IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Mayer <jmayer@loplof.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Apr 2013 15:59:54 +0200
In-Reply-To: <1366639154.8637.18.camel@jlt4.sipsolutions.net> (sfid-20130422_155922_225747_8DC02AA7)
References: <20130419203905.GA15678@rhrk.uni-kl.de>
	 <1366639154.8637.18.camel@jlt4.sipsolutions.net>
	 (sfid-20130422_155922_225747_8DC02AA7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-22 at 15:59 +0200, Johannes Berg wrote:
> On Fri, 2013-04-19 at 22:39 +0200, Joerg Mayer wrote:
> > Small update, found while verifying against the standard.
> > 
> > Thanks
> >     Jörg
> > 
> > The results of a boring train ride:
> > - Decode some IEs sent by other traveller's devices
> >   + IBSS ATIM window
> >   + TPC report
> >   + Old ERP IE (802.11g D4.0)
> > - Tiny whitespace fix
> > - Add Unit 'TUs' to beacon interval.
> 
> Nice, thanks. I changed the unit to just "TU" though :)

Actually, I changed my mind ;-) everything else seems to say "TUs" too

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postla2.htl-leonding.ac.at ([192.88.24.5]:54892 "EHLO
	postla2.htl-leonding.ac.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbYE3OrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:47:01 -0400
From: Michael Grundmann <mgrundmann@htl-leonding.ac.at>
To: linux-wireless@vger.kernel.org
Subject: Re: suspend vs. b43
Date: Fri, 30 May 2008 16:47:30 +0200
References: <1212150713.4117.2.camel@johannes.berg> <200805301631.56899.mgrundmann@htl-leonding.ac.at> <1212158438.4117.6.camel@johannes.berg>
In-Reply-To: <1212158438.4117.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805301647.30742.mgrundmann@htl-leonding.ac.at> (sfid-20080530_164704_916700_D9F3B481)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 30 May 2008 16:40:38 Johannes Berg wrote:
> On Fri, 2008-05-30 at 16:31 +0200, Michael Grundmann wrote:
> > I can reproduce this too on my HP6715s
> > (b43-phy2: Broadcom 4311 WLAN found
> > b43-phy2 debug: Found PHY: Analog 4, Type 2, Revision 9
> > b43-phy2 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2)
> > it hangs while hibernating with tuxonice.
>
> Just a note: this might seem like a different on first sight, but since
> hibernation will actually call resume before powerdown it might be the
> same.
>
> johannes

It works fine when i unload the b43 before.

Michael

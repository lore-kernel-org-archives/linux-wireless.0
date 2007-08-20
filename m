Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:39323 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbXHTLvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 07:51:47 -0400
From: Chr <chunkeey@web.de>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Mon, 20 Aug 2007 13:51:45 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <200708200244.22841.chunkeey@web.de> <46C94844.3080505@hhs.nl>
In-Reply-To: <46C94844.3080505@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708201351.45575.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, 20. August 2007, Hans de Goede wrote:
> Chr wrote:
> > On Tuesday, 14. August 2007, Hans de Goede wrote:
> > 
> > Hans,
> > 
> > Any updates?
> 
> Erm, did you not receive my long mail with all kinda logs attached in logs.tar.gz?
> 
yes I got the logs... but maybe you haven't seen my reply:
http://www.spinics.net/lists/linux-wireless/msg04658.html

>  > Or are you on holiday?
> 
> Nope
> 
> > 
> > I've prepared a patch, which should theoretically lower the excessive retry count.
> > 
> > however I don't think it will magically solve anything...
> > 
> 
> Erm, I'm awfully busy, still I want to get this resolved! So I'll make time to 
> test things as necessary, but could you first look at the logs I send and then 
> confirm (or deny) that this pathc might help.
> 

me too... but the logs don't carry much useful information inside:

"pyh2: not handling 0x02 type control frame" (could be the FW)
"wlan0: duplicate address detected!" (never seen this before... IPv6?)
"wlan0: switched to short barker preamble" (nothing to be scared.)

and of course: the low signal with any driver, except 13-6...

Thanks,
	Chr.

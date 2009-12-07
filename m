Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:43349 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932788AbZLGCLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 21:11:36 -0500
Date: Sun, 6 Dec 2009 21:11:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Otavio Salvador <otavio@ossystems.com.br>
cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.32
In-Reply-To: <be7a9f3d0912061422x5a0fd2f6ubd7add33472a8136@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0912062111100.13023-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 6 Dec 2009, Otavio Salvador wrote:

> Hello Alan,
> 
> On Sun, Dec 6, 2009 at 8:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > When I use 2.6.32 (or indeed 2.6.32-rc1), it works fine up until the
> > point where the wireless card is ifconfig'ed.  Then not long afterward
> > (a few seconds to a minute) the system hangs.
> 
> Did you test it with 2.6.32? Since 2.6.32-rc1 many fixes has been done
> into kernel and would be nice if you could test against current
> kernel.

The same thing happens with both 2.6.32-rc1 and 2.6.32.  But not with 
2.6.31.

Alan Stern


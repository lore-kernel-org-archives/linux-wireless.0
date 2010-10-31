Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56805.mail.re3.yahoo.com ([66.196.97.79]:34696 "HELO
	web56805.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755118Ab0JaLab convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 07:30:31 -0400
Message-ID: <699923.49894.qm@web56805.mail.re3.yahoo.com>
Date: Sun, 31 Oct 2010 04:30:30 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Realtek rtl8188 support?
To: =?iso-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CCCE60F.6090105@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Perhaps not, but I want to have one that works before
> removing the staging driver.
> 
> I think Realtek is serious. After the r8712u driver was
> ready for inclusion in
> staging, I sent them a copy of my revisions to their code.
> Obviously, they
> studied it. When I received the new code for a
> mac80211-based driver for the
> RTL8192CE driver, it was pretty clean and the sort of
> changes that were needed
> for the 8712 had already been done. After only a few hours
> work, the sparse and
> checkpatch warnings and errors were fixed. As far as I can
> tell, this code is

  By "this code" you mean the code for the PCI chips or the USB ones? This topic here mostly touches on the USB cards, which is why I'm asking. And does that mean you'll include the driver once you've tested the cards?

> essentially ready for submission; however, I will wait
> until the sample cards
> arrive from Realtek so that I can test those devices. In
> the very near future,
> Not only will there be a driver for the RTL8188CE/RTL8192CE
> (PCIe), and for the
> RTL8188CU/RTL8192CU (USB) devices. These two families use
> the same chip but
> different interfaces. The new drivers will include a common
> core driver
> (rtlwifi.ko) and an interface driver for each interface
> architecture (rtl8192se
> for PCIe).


      

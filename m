Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2376 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755570AbZABCY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 21:24:26 -0500
Date: Thu, 1 Jan 2009 21:24:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bob Copeland <me@bobcopeland.com>,
	<linux-wireless@vger.kernel.org>,
	<linux-pm@lists.linux-foundation.org>,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
In-Reply-To: <26416.81498.qm@web23106.mail.ird.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.0901012121350.10174-100000@netrider.rowland.org> (sfid-20090102_032431_196861_6F63553F)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 1 Jan 2009, Hin-Tak Leung wrote:

> So it has... I found Documentation/usb/power-management.txt a bit brief...
> and I am planning to read
> http://ols.fedoraproject.org/OLS/Reprints-2008/brown-reprint.pdf
> which seems to be quite relevant...

It doesn't cover USB suspend/resume specifically.  But maybe it will 
help you.

> do you have any recommended readings? I have tried "use the source",
> but the majority of wireless device drivers don't have any
> suspend/resume hooks :-). The behavior of 2.6.26pre - somewhere in
> usbcore forces unloading of all usb device drivers on suspend - was
> useable.

There aren't any other good documents to read, as far as I know.  
2.6.28 also forces unloading of all USB drivers that don't have 
suspend/resume support -- that was the part of the problem which 
started this thread.

Alan Stern


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23106.mail.ird.yahoo.com ([217.146.189.46]:38180 "HELO
	web23106.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754268AbZAAXmW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 18:42:22 -0500
Date: Thu, 1 Jan 2009 23:42:18 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <Pine.LNX.4.44L0.0901011724590.5737-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <26416.81498.qm@web23106.mail.ird.yahoo.com> (sfid-20090102_004232_681753_7D866A2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 1/1/09, Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 1 Jan 2009, Hin-Tak Leung wrote:
> 
> > Also since Alan Stern is now CC'ed, can I ask the
> in-tree skeleton
> > usb driver code updated to reflect the recent
> PM-related changes?
> > There seems to be quite some changes between 2.6.26
> and 2.6.27 .
> 
> It _has_ been updated.  But the USB PM interfaces allow
> several
> different modes of operation, and usb-skeleton can
> illustrate only one
> of them.

So it has... I found Documentation/usb/power-management.txt a bit brief...
and I am planning to read
http://ols.fedoraproject.org/OLS/Reprints-2008/brown-reprint.pdf
which seems to be quite relevant... do you have any recommended readings? I have tried "use the source", but the majority of wireless device drivers don't have any suspend/resume hooks :-). The behavior of 2.6.26pre - somewhere in usbcore forces unloading of all usb device drivers on suspend - was useable.

Hin-Tak


      

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2353 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750733AbZAAWZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 17:25:58 -0500
Date: Thu, 1 Jan 2009 17:25:55 -0500 (EST)
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
In-Reply-To: <584629.91849.qm@web23108.mail.ird.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.0901011724590.5737-100000@netrider.rowland.org> (sfid-20090101_232618_974047_9A7E9545)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 1 Jan 2009, Hin-Tak Leung wrote:

> Also since Alan Stern is now CC'ed, can I ask the in-tree skeleton
> usb driver code updated to reflect the recent PM-related changes?
> There seems to be quite some changes between 2.6.26 and 2.6.27 .

It _has_ been updated.  But the USB PM interfaces allow several
different modes of operation, and usb-skeleton can illustrate only one
of them.

Alan Stern


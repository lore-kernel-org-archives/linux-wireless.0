Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2115 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750933AbZAAAQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 19:16:47 -0500
Date: Wed, 31 Dec 2008 19:16:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	<htl10@users.sourceforge.net>, Bob Copeland <me@bobcopeland.com>,
	<linux-wireless@vger.kernel.org>,
	<linux-pm@lists.linux-foundation.org>,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
In-Reply-To: <495BF975.7030603@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.0812311915350.12880-100000@netrider.rowland.org> (sfid-20090101_011654_231844_CA55F2FF)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 31 Dec 2008, Larry Finger wrote:

> Here is a second try at a suspend/resume patch for rtl8187. This one
> also seems a bit too easy; however, it did work for me, at least for
> STD. I now realize that my machine didn't power off in my previous
> test. This time I manually turned it off before restarting. My
> computer still doesn't STR, thus that was not tested.

As Oliver pointed out, you generally need to implement a reset_resume
method for hibernation to work.  See 
Documentation/usb/power-management.txt.

Alan Stern


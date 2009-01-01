Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23108.mail.ird.yahoo.com ([217.146.189.48]:37979 "HELO
	web23108.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750870AbZAAGGl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 01:06:41 -0500
Date: Thu, 1 Jan 2009 06:06:38 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <495BC8F9.4040203@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <584629.91849.qm@web23108.mail.ird.yahoo.com> (sfid-20090101_070654_810938_FBEEEBC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 31/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
<snipped>
> Thanks for testing. I have some ideas on how to improve the
> suspend/resume, but they will require some changes in the
> structure. I
> will also try to determine why my system fails at STR so I
> can test
> both flavors.

I had a crash STR, after restoring my SUSPEND_MODULES workaround , so it is possible that the new addition actually stop the module getting unloaded. In any case, I suggest testing STR/STD while leaving a ping to the router running, just to be sure that the suspend/resume code does the right thing.

Also since Alan Stern is now CC'ed, can I ask the in-tree skeleton usb driver code updated to reflect the recent PM-related changes? There seems to be quite some changes between 2.6.26 and 2.6.27 .

Cheers,
Hin-Tak 


      

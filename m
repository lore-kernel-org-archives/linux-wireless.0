Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51402.mail.re2.yahoo.com ([206.190.38.181]:42415 "HELO
	web51402.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754575Ab0ECNVA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 09:21:00 -0400
Message-ID: <469051.90774.qm@web51402.mail.re2.yahoo.com>
Date: Mon, 3 May 2010 06:20:59 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH] mac80211: improve IBSS scanning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1272892320.3614.34.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> WHY is it required for you? And yeah, I _am_ still opposed
> to that.

Please don't laugh! Really, don't!

We have an embedded system that normally uses an IBSS network
as a delivery system (can be deployed for field measurements).
Some customers were unhappy that the networks could be detected
on WLAN snoopers like Netstumbler. The quick and dirty solution
to make the networks invisible was using the AH-demo mode.

Now "invisible on Netstumbler" is an advertised feature that
must be maintained for ever after (the GUI has a checkbox 
"hide from Netstumbler").

Regards
  Joerg



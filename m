Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linode.cmadams.net ([209.123.162.222]:45373 "EHLO
	linode.cmadams.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab3FSRBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 13:01:11 -0400
Date: Wed, 19 Jun 2013 11:42:27 -0500
From: Chris Adams <cmadams@cmadams.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4331 deauthenticates every five minutes
Message-ID: <20130619164227.GC4784@cmadams.net> (sfid-20130619_190114_722179_27E402A5)
References: <20130619160911.GB4784@cmadams.net>
 <51C1DDEB.3090701@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51C1DDEB.3090701@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once upon a time, Larry Finger <Larry.Finger@lwfinger.net> said:
> What type of encryption are you using? If it is a re-keying type
> such as TKIP, what is the interval? You should find that on the
> setup page of the access point.

I don't have access to the management of this particular AP (work
environment), but "iw dev wlan0 scan dump" says CCMP.

> BTW, your mailer is set up strangely. I get your address when I do a
> plain Reply, but a Reply All from Thunderbird only got the b43-dev
> mailing list. I had to add your address manually.

I'm using Mutt, which sets "Mail-Followup-To: <listaddr>" for configured
mailing lists.  If you were just replying to the b43-dev list, a CC to
me isn't really needed (I subscribed before sending; didn't know if
non-subscribers were allowed to send messages).

-- 
Chris Adams <cmadams@cmadams.net>

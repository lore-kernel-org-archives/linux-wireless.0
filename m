Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51401.mail.re2.yahoo.com ([206.190.38.180]:27199 "HELO
	web51401.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754422Ab0A1IfA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 03:35:00 -0500
Message-ID: <451620.55807.qm@web51401.mail.re2.yahoo.com>
Date: Thu, 28 Jan 2010 00:34:59 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH] cfg80211: fix wext-compat for setting rate to 'auto'
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100127161725.GC2962@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,
I switched between a fixed data rate and automatic selection. Selecting a
fixed data rate seems to work fine. I can't be 100% sure, because the
RC algorithm might have decided to pick exactly this rate, but this would
be very unlikely. Switching back to auto looks good, too.

-- 
Regards
       Joerg


--- John W. Linville <linville@tuxdriver.com> schrieb am Mi, 27.1.2010:

> Von: John W. Linville <linville@tuxdriver.com>
> Betreff: Re: [PATCH] cfg80211: fix wext-compat for setting rate to 'auto'
> An: "Joerg Pommnitz" <pommnitz@yahoo.com>
> CC: linux-wireless@vger.kernel.org
> Datum: Mittwoch, 27. Januar 2010, 17:17
> On Wed, Jan 27, 2010 at 07:51:06AM
> -0800, Joerg Pommnitz wrote:
> > John,
> > thanks for the quick response. The patch works fine
> for me. Feel free to add a
> > 
> > Tested-by: "Joerg Pommnitz" <pommnitz@yahoo.com>
> 
> Joerg,
> 
> I still haven't had time for a reboot. :-(  I wonder
> if you tested
> to make sure that using "fixed" or just a rate by itself
> still works
> properly too?
> 
> Thanks!
> 
> John
> -- 
> John W. Linville       
> Someday the world will need a hero, and you
> linville@tuxdriver.com   
>         might be all we
> have.  Be ready.
> 

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 

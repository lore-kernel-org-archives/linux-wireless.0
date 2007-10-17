Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.uludag.org.tr ([193.140.100.220]:57302 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751239AbXJQMSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 08:18:22 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Problem with in-kernel iwl3945 driver
Date: Wed, 17 Oct 2007 15:18:36 +0300
Cc: linux-wireless@vger.kernel.org
References: <200710161317.45460.ismail@pardus.org.tr> <200710161703.51343.ismail@pardus.org.tr> <1192609081.8841.8.camel@johannes.berg>
In-Reply-To: <1192609081.8841.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200710171518.36393.ismail@pardus.org.tr> (sfid-20071017_131830_903211_C472B532)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wednesday 17 October 2007 Tarihinde 11:18:01 yazm=C4=B1=C5=9Ft=C4=B1:
> On Tue, 2007-10-16 at 17:03 +0300, Ismail D=C3=B6nmez wrote:
> > Replying to myself,
> >
> > Tuesday 16 October 2007 Tarihinde 13:17:45 yazm=C4=B1=C5=9Ft=C4=B1n=
=C4=B1z:
> > [...]
> >
> > > wlan0     IEEE 802.11b  ESSID:"XXYYZZ"
> >
> >                          ^^^^^^^
> > Looks like its in 802.11b mode instead of 802.11g.  That might be a=
 clue
> > for slowdown.
>
> A fix was committed under the title "fix set_channel regression"

This indeed fixes the slowdown, but can't associate unless I do a iwlis=
t scan=20
problem still persists :-/

Regards,
ismail

--=20
=46aith is believing what you know isn't so -- Mark Twain
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45453 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759164AbYFZQB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 12:01:28 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Pavel Roskin <proski@gnu.org>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <1214449044.18897.15.camel@dv> <1214487200.20763.44.camel@johannes.berg>
	 <1214492236.30044.7.camel@dv>
	 <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 26 Jun 2008 12:01:26 -0400
Message-Id: <1214496086.30722.14.camel@dv> (sfid-20080626_180135_611425_FD10BB4B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-26 at 17:46 +0200, Stefanik G=E1bor wrote:

> Maybe we had more people working on/debugging AP mode if we didn't
> intentionally disable the existing limited support for it... Possibly
> print a big warning that "THIS IS NOT STANDARDS_COMPLIANT YET!", but
> outright disabling it and requiring an external patch is IMHO stupid.
> Perhaps a Kconfig option with EXPERIMENTAL and default=3Dn would be
> better.

I agree.  More people would be looking into AP support for individual
drivers if mac80211 didn't need a patch.

Alone the requirement for hostapd would indicate that the AP mode is no=
t
ready for general consumption.  Going further can actually discourage
some potential contributors.

I suspect somebody in the ath5k camp would look at the AP mode if
mac80211 wasn't forbidding it unconditionally.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

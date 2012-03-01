Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:38969 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758018Ab2CAK53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 05:57:29 -0500
Date: Thu, 1 Mar 2012 12:57:21 +0200
From: Jouni Malinen <j@w1.fi>
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: linux-wireless@vger.kernel.org,
	Till Kamppeter <till.kamppeter@gmail.com>
Subject: Re: Fw: Google summer of code application for organization opened;
 wireless projects.
Message-ID: <20120301105721.GA4560@w1.fi> (sfid-20120301_115732_509433_6E79C1AA)
References: <1330464499.83094.YahooMailClassic@web29501.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330464499.83094.YahooMailClassic@web29501.mail.ird.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> --- On Tue, 28/2/12, Hin-Tak Leung <htl10@users.sourceforge.net> wrote:
> > Came across some android-specific issues concerning wifi
> > support:
> > http://linuxwireless.org/en/developers/Documentation/Android
> > 
> > some of them probably would make a nice GSoC project. (using
> > unmod'ed wpa_supplicant, gui for setting up ad-hoc mode,
> > etc).

While there are areas that can certainly be improved in Android WLAN
support, please note that this page is quite old and not at all accurate
with the latest Android release (ICS). WEXT has been mostly replaced
with nl80211 and wpa_supplicant is much closer to the upstream version.

-- 
Jouni Malinen                                            PGP id EFC895FA

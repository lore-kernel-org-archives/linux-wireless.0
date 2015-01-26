Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54363 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbbAZI01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 03:26:27 -0500
Message-ID: <1422260785.1890.8.camel@sipsolutions.net> (sfid-20150126_092630_449411_25DADDA7)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Jan 2015 09:26:25 +0100
In-Reply-To: <CA+XVXfdXv5s_hs+jdpshGjo7RdS7fCW52F82Ojf4wQ90fVoCiw@mail.gmail.com> (sfid-20150125_112538_055815_33705601)
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
	 <1422007493.2728.26.camel@sipsolutions.net>
	 <CA+XVXfdXv5s_hs+jdpshGjo7RdS7fCW52F82Ojf4wQ90fVoCiw@mail.gmail.com>
	 (sfid-20150125_112538_055815_33705601)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-01-25 at 12:25 +0200, Arik Nemtsov wrote:

> >> +u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> >> +                             const struct cfg80211_chan_def *chandef)
> >
> > I still think you should keep this a static function in ibss.c since
> > nobody else is going to use it soon - the only possible user is mesh
> > anyway I think.
> 
> Actually TDLS needs to use it pretty soon as well :)

Ok, fair enough.

johannes


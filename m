Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29250 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbZGGVVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 17:21:47 -0400
Subject: Re: ath5k and ap mode
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: tomek <paladyn11@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0907071243i7380ef9cm857fd189025a92a9@mail.gmail.com>
References: <1246959589.4686.1.camel@debian-tomek>
	 <b6c5339f0907070719l2db5aec3rc20160eabd41fd0a@mail.gmail.com>
	 <1246994723.3393.14.camel@mj>
	 <b6c5339f0907071243i7380ef9cm857fd189025a92a9@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 17:21:45 -0400
Message-Id: <1247001705.3393.53.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-07 at 15:43 -0400, Bob Copeland wrote:
> On Tue, Jul 7, 2009 at 3:25 PM, Pavel Roskin<proski@gnu.org> wrote:
> >
> > WPA: Countermeasures - dropped EAPOL request.
> >
> > I'm using WPA-PSK (WPA1 only) to simplify the configuration.  My
> > impression is that we need a serious effort to weed out such problems.
> 
> Hmm, does the same happen with nohwcrypt=1?

"Pairwise with unexpected replay counter" is still there.  But the
timeouts (deauthenticated due to local deauth request" in hostapd and
"Authentication with 00:00:00:00:00:00 timed out" in wpa_supplicant) are
gone, so the association happens quicker, after a few complaints about
the counters.

I tried CCMP and WPA2, and "Pairwise with unexpected replay counter"
still happens.

I'm using the current hostapd from git, but it's working with MadWifi
without such issues.

-- 
Regards,
Pavel Roskin

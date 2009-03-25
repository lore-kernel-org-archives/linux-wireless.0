Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZCYUJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 16:09:52 -0400
Subject: Re: wireless powersaving (in NM?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1238011579.4320.169.camel@johannes.local> (sfid-20090325_210659_076895_F94E2630)
References: <1237891149.4320.73.camel@johannes.local>
	 <87ab7bqa21.fsf@litku.valot.fi> <1237978630.4320.150.camel@johannes.local>
	 <87ab791isj.fsf@litku.valot.fi>
	 (sfid-20090325_205334_758597_39212B61)  <1238011579.4320.169.camel@johannes.local>
	 (sfid-20090325_210659_076895_F94E2630)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qigyc66DGB72AhX186Q8"
Date: Wed, 25 Mar 2009 21:09:20 +0100
Message-Id: <1238011760.4320.171.camel@johannes.local> (sfid-20090325_210955_485092_48886AD7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qigyc66DGB72AhX186Q8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 21:06 +0100, Johannes Berg wrote:

> > > I'm just worried that we'll require a whole bunch of different
> > > interfaces. Yes, in theory there isn't much to control, but iwlwifi
> > > firmware for example can, as far as I interpret the code, dynamically
> > > vary the listen interval.
> >=20
> > You mean the wakeup interval? For me, listen interval means the
> > maximum time AP is willing to buffer frames for a STA.
>=20
> No, I mean the listen interval in the assoc request frame.

...

> > I think stlc45xx/p54 even had something
> > similar. But honestly, I don't know if this kind of trickery is
> > useful. Why not directly go to the longest wakeup interval
> > immediately?
>=20
> But listen interval * beacon interval determines latency.

although, of course, the listen interval in the assoc request is just
the local max -- since the AP already sets the TIM bit as soon as it has
data buffered we can wake up earlier if we want to.

In a sense, therefore, the listen interval determines the maximum
latency we and the AP are willing to put up with.

johannes

--=-qigyc66DGB72AhX186Q8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyo9uAAoJEKVg1VMiehFYVTIP/1LbAshE5+a8uduV21mPbGY2
9kXG01a3g0imXyw7ky5tSQ29Mgx4A2IS6S7rChyCiBXnQxnVCpuHFFPE1N0OQHv1
MP+vcc57WFWOJq+u/ZALWexzL+5/NIrCuNAAGwpJbOO4V0GC9NPuff73awZYREmm
zvqgwGTwSee9fvBr7THEX/iG0ZjFyVY9yRIdYyaD1UiMmulnoX+ECtnrW8CpsC2P
b6FTM/muZ3C0aAqI/TprdS7PLhU/Ff/5htaeCPLyMHMLo9saiDkn3RHa38qWBOEC
iixVj4b/41P72sH5LW165eSZQ8AZyXq9E19Xh11GGH+EdMvsSTnW5kFLlNlpBmM4
+2053cn8ksQ7v16ktjSZow3WCvcwN/D0talcQlBqOwPRgdIdvMTf5XvAZ1Cnq9CM
zMu+fH75k/7k4+07sKgbWz4LsxBrpOoJ21bKzoCB8wr68re2GjmYg891Ptz64zHV
8h9EQlCYFmvjX9n+L2uh5bfc0E9IZKfjSfLsbuLwLGgzhNrSCsrS2Xpe3eATtMJ/
g7JRuOCkBiXfqJo6NR3ZRa7VK+YfggiKTRHcr7SxnfU3C+aDDJ/G9F+Hbtcy1zYN
Htvv/L8Dwehbgffsvfv333AiET6m6upE9CWpJeJ0qxx4BRQYHtQuEpTjzSPzmF91
brYPLXbvtD+WO2hVKlRn
=6JuA
-----END PGP SIGNATURE-----

--=-qigyc66DGB72AhX186Q8--


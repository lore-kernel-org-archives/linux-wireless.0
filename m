Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:55894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbXJULkY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 07:40:24 -0400
From: Andreas Schwab <schwab@suse.de>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: b43: cannot set channel to 12
References: <jey7e1leh0.fsf@sykes.suse.de> <4716676C.5010907@lwfinger.net>
Date: Sun, 21 Oct 2007 13:40:22 +0200
In-Reply-To: <4716676C.5010907@lwfinger.net> (Larry Finger's message of "Wed\,
	17 Oct 2007 14\:50\:04 -0500")
Message-ID: <jesl44n1ax.fsf@sykes.suse.de> (sfid-20071021_124027_795472_E103207C)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <larry.finger@lwfinger.net> writes:

> This is not a b43 problem. The standard loading of mac80211 sets an F=
CC regulatory domain, i.e. b/g
> channels 1-11. You need to load mac80211 with a parameter of 'ieee802=
11_regdom=3D64'. That will allow
> b/g channels 1-13. Technically, it sets the regulatory domain to Japa=
n, but channel 14 is not allowed.

Thanks, that works.  (But I regard it as a regression.)

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

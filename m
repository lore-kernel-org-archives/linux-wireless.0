Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38559 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755218AbZAFSfp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 13:35:45 -0500
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 06 Jan 2009 19:35:43 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1231247805.3503.13.camel@johannes>
Message-ID: <20090106183543.241290@gmx.net> (sfid-20090106_193603_039998_AA3BC528)
MIME-Version: 1.0
References: <20090106014135.302730@gmx.net>	
 (sfid-20090106_024205_979845_6893AA18) <1231247805.3503.13.camel@johannes>
Subject: Re: [PATCH] Fixed BSSID step 1: Disallow to set multicast BSSID
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> These look ok to me, with proper changelogs. Thanks. You should have
> made the subjects
>=20
> [PATCH 1/5] mac80211: Disallow ...
>=20
> etc. and also line-wrapped the changelogs, since these are fed direct=
ly
> into git normally.

Okay, but can I do this with the next patches and not repost all this a=
gain?

Is there somewhere a git repository, with all the new patches merged? S=
o that I have link where other people can download easily the newest ve=
rsion and test it, to maybe look for other problem in the ad hoc mode, =
before it is in compat-wireless.

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

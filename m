Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36429 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZD3TQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 15:16:04 -0400
Date: Thu, 30 Apr 2009 15:02:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 0/5] mac80211, iwlwifi, ath9k: Fix rate scaling for
	IEEE80211_TX_CTL_NO_ACK packets
Message-ID: <20090430190207.GD9323@tuxdriver.com>
References: <69e28c910904231035u7ff2d9bbnbf1a74ece718659@mail.gmail.com> <69e28c910904281353n327a6dfcjb0389f2e2e55dea2@mail.gmail.com> <20090430182806.GA9323@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090430182806.GA9323@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 30, 2009 at 02:28:07PM -0400, John W. Linville wrote:
> On Tue, Apr 28, 2009 at 10:53:51PM +0200, G=E1bor Stefanik wrote:
> > Did this get lost? I can't see it in wireless-testing.
>=20
> No, I didn't lose them.  I was waiting to process them until I had
> a little extra time, because nearly every patch you send me requires
> manually intervention before I can apply it.  This is quite painful
> and it increases the time I need for merging patches exponentially.
>=20
> Please, please, please ensure that:
>=20
> 	-- you are using a recent pull of wireless-testing;
>=20
> 	-- you're patches are based directly on wireless-testing and
> 	   not on top of any other patches you have not submitted;
>=20
> 	-- you format your patch and changelog compatibly with what
> 	   is described here:
>=20
> 		http://linux.yyz.us/patch-format.html
>=20
> 	-- you send the patch inline (without MIME) in email if at
> 	   all possible;
>=20
> 	-- if you simply must send a patch as an attachment then do
> 	   so, but...
>=20
> 	-- do _not_ send a patch inline _and_ attached to the same
> 	   email

=46orgot one:

	-- successfully compile a current wireless-testing tree with
	   your patches applied...

>=20
> The above are not strictly directed at you, G=E1bor.

That one is...

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

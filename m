Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59663 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZD3SbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 14:31:06 -0400
Date: Thu, 30 Apr 2009 14:28:07 -0400
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
Message-ID: <20090430182806.GA9323@tuxdriver.com>
References: <69e28c910904231035u7ff2d9bbnbf1a74ece718659@mail.gmail.com> <69e28c910904281353n327a6dfcjb0389f2e2e55dea2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910904281353n327a6dfcjb0389f2e2e55dea2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 28, 2009 at 10:53:51PM +0200, G=E1bor Stefanik wrote:
> Did this get lost? I can't see it in wireless-testing.

No, I didn't lose them.  I was waiting to process them until I had
a little extra time, because nearly every patch you send me requires
manually intervention before I can apply it.  This is quite painful
and it increases the time I need for merging patches exponentially.

Please, please, please ensure that:

	-- you are using a recent pull of wireless-testing;

	-- you're patches are based directly on wireless-testing and
	   not on top of any other patches you have not submitted;

	-- you format your patch and changelog compatibly with what
	   is described here:

		http://linux.yyz.us/patch-format.html

	-- you send the patch inline (without MIME) in email if at
	   all possible;

	-- if you simply must send a patch as an attachment then do
	   so, but...

	-- do _not_ send a patch inline _and_ attached to the same
	   email

The above are not strictly directed at you, G=E1bor.  You just were
lucky enough to be asking at the right time...

Thanks,

John

P.S.  Out of these five patches, 4 of them required manual intervention=
=2E..
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

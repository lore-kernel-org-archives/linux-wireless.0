Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58286 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXJWMfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 08:35:04 -0400
Date: Tue, 23 Oct 2007 13:43:18 +0200
To: Ian Schram <ischram@telenet.be>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] [RFC][PATCH] iwlwifi using mac80211_leds
Message-ID: <20071023114318.GI25672@gamma.logic.tuwien.ac.at> (sfid-20071023_133516_680184_B460A040)
References: <47164DA9.3050001@telenet.be> <9f50a7a00710222311u7ae17958w596c3d579fb31536@mail.gmail.com> <1193120114.3069.256.camel@debian.sh.intel.com> <loom.20071023T104428-443@post.gmane.org> <471DDDD0.4060007@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <471DDDD0.4060007@telenet.be>
From: Norbert Preining <preining@logic.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Di, 23 Okt 2007, Ian Schram wrote:
> > I would like to, is there a way to patch this into the git sources?

> the intellinuxwireless.org gits? to make it work it would require an update

Sorry for being unclear, I meant the iwlwifi git sources (so currently
the 1.1.18 one).

> of the mac80211 package, and compatibility with older kernels is probably
> pretty nasty.

Ah, ok, so I would have to use the mac80211.git source, too.

> the association led is only in the very latest git sources, i'm guessing only
> wireless-2.6 for now.

Ok, so 2.6.23-mm1 should do the trick, am I right?

> I'll try to send a patch a bit later today to fix a few of the outstanding issues.

Thanks.


Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
EWELME (n.)
The smile bestowed on you by an air hostess.
			--- Douglas Adams, The Meaning of Liff

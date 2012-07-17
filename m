Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:50407 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858Ab2GQUdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 16:33:44 -0400
Message-ID: <5005CC26.6090408@net.t-labs.tu-berlin.de> (sfid-20120717_223348_191733_7E84BB3E)
Date: Tue, 17 Jul 2012 22:33:42 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: coelho@ti.com, brcm80211-dev-list@broadcom.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, ilw@linux.intel.com,
	ath9k-devel@lists.ath9k.org, b43-dev@lists.infradead.org,
	chunkeey@googlemail.com, dsd@gentoo.org, buytenh@wantstofly.org
Subject: Re: [ath5k-devel] [PATCH 2/2] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
References: <1342205545-45382-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1342205545-45382-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120713_205245_114771_49FF4AC7) <1342518290.7427.9.camel@jlt3.sipsolutions.net> <5005613F.1000004@net.t-labs.tu-berlin.de> <1342530237.8139.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1342530237.8139.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,


> No, I'm not going to play that game. Make sure it compiles on
> wireless-next.

Virtual box did the job and I found 3 drivers that somehow did not
complain in my OpenWRT build env... thx for not playing :)... v3 is out.

I used wireless-testing and not -next,as in -next the necessary patch
for mwlk8 is not included but in -testing. So my general question is on
which tree to develop, on testing or next?

Greetings Thomas



> 
> 
> _______________________________________________
> b43-dev mailing list
> b43-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/b43-dev


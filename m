Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61727 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZFBWaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 18:30:08 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 15:30:11 -0700
Date: Tue, 2 Jun 2009 15:30:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Andrey Yurovsky <andrey@cozybit.com>
CC: "austinxxh-ath9k@yahoo.com" <austinxxh-ath9k@yahoo.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k/ath5k + 80211s crash
Message-ID: <20090602223016.GF11052@tesla>
References: <661650.46971.qm@web55304.mail.re4.yahoo.com> <45e8e6c40906020958x3de155acx1011452051c9e96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <45e8e6c40906020958x3de155acx1011452051c9e96@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2009 at 09:58:59AM -0700, Andrey Yurovsky wrote:
> With wireless-testing from a couple of days ago, an X86 system, and this patch:
> http://osdir.com/ml/linux-wireless/2009-05/msg01241.html
> ath9k can bring up a mesh point interface and doesn't crash for me,
> but there are no mesh beacons, so mesh isn't working.  On ath5k, there
> are also no beacons and mesh doesn't work, but there's no crash.

If no one is really interested in fixing we should just disable mesh
for both ath5k and ath9k.

  Luis

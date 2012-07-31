Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab2GaREs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 13:04:48 -0400
Message-ID: <1343754285.4474.8.camel@jlt3.sipsolutions.net> (sfid-20120731_190451_351748_49CB6995)
Subject: Re: [PATCH 1/3] wireless: add radiotap A-MPDU status field
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 31 Jul 2012 19:04:45 +0200
In-Reply-To: <01F94E3A-B132-46B2-9B4E-E2F78135458D@gmail.com> (sfid-20120731_190053_053151_A750B763)
References: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
	 <1343734541-14934-2-git-send-email-johannes@sipsolutions.net>
	 <01F94E3A-B132-46B2-9B4E-E2F78135458D@gmail.com>
	 (sfid-20120731_190053_053151_A750B763)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-31 at 19:00 +0200, Gertjan van Wingerde wrote:

> > + * IEEE80211_RADIOTAP_AMPDU_STATUS    u32, u16, u8, u8    unitlesss
> 
> Just a minor nit, but there seems to be an 's' too many in unitlesss above.

Good catch, thanks. I fixed it, but I'm not going to repost the patches
for it :-)

johannes


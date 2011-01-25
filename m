Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13928 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1AYFLX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 00:11:23 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 21:11:03 -0800
Date: Tue, 25 Jan 2011 10:40:36 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Paul Stewart <pstew@google.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Fix power save usage count imbalance on deinit
Message-ID: <20110125051036.GA7314@vmraj-lnx.users.atheros.com>
References: <1295452063-13828-1-git-send-email-rmanoharan@atheros.com>
 <1295452063-13828-2-git-send-email-rmanoharan@atheros.com>
 <AANLkTimSBJxY0f6G6BLcLbsDySvn6KZQu=Vdj134yZLD@mail.gmail.com>
 <20110120075130.GA3431@vmraj-lnx.users.atheros.com>
 <AANLkTim4d5xBBRnzWDoyZhJKriX3MByA-XbHsnTOW5+B@mail.gmail.com>
 <20110123072116.GA7170@vmraj-lnx.users.atheros.com>
 <AANLkTimJB1QJ63f_=RPRuMXGnt95+y9LQzpAMmcEcLx2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTimJB1QJ63f_=RPRuMXGnt95+y9LQzpAMmcEcLx2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 05:33:31AM +0530, Paul Stewart wrote:
> This change doesn't regress the issue with scan-during-suspend.  The
> other regression you should test for is that the system really does
> continue to honor powersave after a suspend-resume cycle (verify
> null-functions and drop in power consumption).  You should be able to
> do that yourself, and I'd suggest testing for this case as well before
> committing any changes to powersave.
>
Thanks a lot Paul for validating the patch. Sure I will do more testing
with this patch.

--
Rajkumar

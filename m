Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57561 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbZHHIJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 04:09:12 -0400
Received: by bwz19 with SMTP id 19so1817083bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 01:09:11 -0700 (PDT)
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: Re: [PATCH 3/8] mac80211: Simulate transmission losses on plinks to aid in testing mesh metrics.
References: <1249702711-32737-1-git-send-email-javier@cozybit.com>
	<1249702711-32737-2-git-send-email-javier@cozybit.com>
	<1249702711-32737-3-git-send-email-javier@cozybit.com>
	<1249702711-32737-4-git-send-email-javier@cozybit.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 08 Aug 2009 11:09:09 +0300
In-Reply-To: <1249702711-32737-4-git-send-email-javier@cozybit.com> (Javier Cardona's message of "Fri\,  7 Aug 2009 20\:38\:26 -0700")
Message-ID: <87d476n2vu.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier Cardona <javier@cozybit.com> writes:

> This enables us to specify a simulated loss probability per mesh peer link.
> Useful to simulate and test different mesh topologies and test different mesh
> metrics.
>
> The simulated loss rate setting can be configured as a plink action.  The
> intended use is:
>
> iw dev mesh station set <MAC> plink_action loss 25

I really would not like to see debug functionality in nl80211 just to
simplify the maintenance. Debugging belongs to debugfs or somewhere
else.

Disclaimer: I know nothing about mesh and I may have misunderstood
something.

-- 
Kalle Valo

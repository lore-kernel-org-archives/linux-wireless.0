Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1080 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237AbZCSAqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 20:46:35 -0400
Date: Wed, 18 Mar 2009 20:44:12 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] mac80211: Tear down aggregation sessions for
	suspend/resume
Message-ID: <20090319004412.GF18141@hash.localnet> (sfid-20090319_014645_913994_32B0A347)
References: <18879.5862.135522.858638@gargle.gargle.HOWL> <1237276019.18086.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1237276019.18086.7.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2009 at 08:46:59AM +0100, Johannes Berg wrote:
> On Tue, 2009-03-17 at 08:50 +0530, Sujith wrote:
> > This can be fixed by tearing down the existing sessions on a suspend.
> > 
> > v3:
> > ---
> > * Use RCU protection when shutting down BA sessions for STAs.
> 
> Thanks for your patience :)
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

FWIW, I finally tested this formulation and it works fine on my hardware,
so I think the deadlock is long buried.

-- 
Bob Copeland %% www.bobcopeland.com


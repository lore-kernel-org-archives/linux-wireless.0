Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:29228 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbZBLCQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 21:16:40 -0500
Received: by wf-out-1314.google.com with SMTP id 28so520420wfa.4
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 18:16:39 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
Message-ID: <18835.34347.918619.481986@gargle.gargle.HOWL> (sfid-20090212_031644_775315_532EB7B9)
Date: Thu, 12 Feb 2009 07:45:07 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: mementux <mementux@gmail.com>,
	Michael Green <Michael.Green@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] Radar Detection and DFS status
In-Reply-To: <43e72e890902111341l36bd40c8o9d54515e8b06e603@mail.gmail.com>
References: <2d14e2ca0902110900r7f0b84e4k7be81827187c434@mail.gmail.com>
	<43e72e890902111341l36bd40c8o9d54515e8b06e603@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> mac80211 or ath9k does not yet have radar detection support so
> therefore no mac80211 driver will allow you to use any beaconing mode
> (AP | IBSS | Mesh) mode on DFS channels yet.
> 
> Note that not all 5 GHz channels require radar detection though so you
> could try using one of the non-DFS channels. Check 'iw list' for that.
> 
> ath9k STA should work with DFS but I didn't work on that myself so
> will leave someone else to comment on that.

Yep, STA mode should work fine, since 802.11h CSA support was added to
mac80211 recently.

Sujith
-- 
http://sujith-m.blogspot.com

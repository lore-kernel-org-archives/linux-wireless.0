Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:41813 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754804Ab1KDDH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 23:07:29 -0400
Message-ID: <20111104030046.25361.qmail@stuge.se> (sfid-20111104_040738_212388_DCE6821D)
Date: Fri, 4 Nov 2011 04:00:46 +0100
From: Peter Stuge <peter@stuge.se>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com
Subject: Re: [ath9k-devel] [RFC v2 2/2] ath9k: integrate initial DFS module
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com> <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com> <201111031651.46073.chunkeey@googlemail.com> <4EB2CE96.4060702@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4EB2CE96.4060702@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi wrote:
> Just clarify whether you do not like the CONFIG_ prefix or the fact
> that it can't be enabled.

It's IMO always stupid to add dead code. No exceptions for
$random_authority_which_has_no_jurisdiction_for_billions_of_users.


//Peter

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38801 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaCGKTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 05:19:03 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21273.40172.734118.220513@gargle.gargle.HOWL> (sfid-20140307_111916_531299_EB509D3D)
Date: Fri, 7 Mar 2014 15:48:20 +0530
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 00/23] ath9k|ath9k_htc: move dups to common-beacon
In-Reply-To: <5319978F.6060803@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
	<21266.37896.937680.416439@gargle.gargle.HOWL>
	<5312DD46.3030800@rempel-privat.de>
	<21266.58035.719712.344551@gargle.gargle.HOWL>
	<20140306184235.GA7788@tuxdriver.com>
	<5319978F.6060803@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel wrote:
> Last response was about initvals, my patch set affect only beacon code.
> Since i don't plan to rewrite ath9k_htc from scratch, i would assume it
> will be better to continue this periodic clean work.

I didn't review the patches, but someone else needs to make sure that
nothing is broken in ath9k.

Sujith

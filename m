Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42516 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517AbYLKWCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 17:02:08 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: Re: [PATCH] ath5k : Fix correct padding
Date: Thu, 11 Dec 2008 22:58:24 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <49418D23.8060905@free.fr>
In-Reply-To: <49418D23.8060905@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812112258.25007.mb@bu3sch.de> (sfid-20081211_230212_942339_6F33AB66)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 11 December 2008 22:58:59 Benoit PAPILLAULT wrote:
> Padding the 802.11 header to a multiple of 4 bytes needs to be done only
> for DATA frames.

Uhm, can you explain _why_ it's only needed for data frames?


-- 
Greetings, Michael.

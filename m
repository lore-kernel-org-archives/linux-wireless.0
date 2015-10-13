Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51426 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbbJMIbs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 04:31:48 -0400
Message-ID: <1444725101.1961.2.camel@sipsolutions.net> (sfid-20151013_103159_181743_7CB988D5)
Subject: Re: [PATCH] Revert "mac80211: remove exposing 'mfp' to drivers"
From: Johannes Berg <johannes@sipsolutions.net>
To: c_traja@qti.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Oct 2015 10:31:41 +0200
In-Reply-To: <1444194604-12637-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1444194604-12637-1-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-07 at 10:40 +0530, c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> 
> This reverts commit 5c48f1201744233d4f235c7dd916d5196ed20716.
> 
> Some device drivers (ath10k) offload part of aggregation including 
> AddBA/DelBA
> negotiations to firmware. In such scenario, the PMF configuration of
> the station needs to be provided to driver to enable encryption of
> AddBA/DelBA action frames.
> 
Applied.

johannes

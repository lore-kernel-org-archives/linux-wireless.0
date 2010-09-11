Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3583 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab0IKR3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 13:29:25 -0400
Date: Sat, 11 Sep 2010 13:25:24 -0400
From: bob@bobcopeland.com
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Subject: Re: [PATCH 5/8] ath/ath9k: Replace common->splitmic with a flag
Message-ID: <20100911172524.GG20385@hash.localnet>
References: <20100908070427.11255.17659.stgit@tt-desk> <20100908070454.11255.14931.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100908070454.11255.14931.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 08, 2010 at 04:04:54PM +0900, Bruno Randolf wrote:
> Replace common->splitmic with ATH_CRYPT_CAP_MIC_COMBINED flag.
> 
> splitmic has to be used when the ATH_CRYPT_CAP_MIC_COMBINED capability flag is
> not set.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com


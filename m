Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:10580 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbZIAWD1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 18:03:27 -0400
Subject: Re: [PATCH 4/4] ath5k: add hardware CCMP encyption support
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <20090827191715.GA30419@hash.localnet>
References: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
	 <1251169233-24169-5-git-send-email-me@bobcopeland.com>
	 <1251338971.17295.17.camel@mj>  <20090827191715.GA30419@hash.localnet>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 18:03:22 -0400
Message-Id: <1251842602.14862.82.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-27 at 15:17 -0400, Bob Copeland wrote:
> -	ah->ah_aes_support =
> +	ah->ah_aes_support = srev >= AR5K_SREV_AR5212_V4 &&

Fine with me, but please use parentheses here, just for readability:

h->ah_aes_support = (srev >= AR5K_SREV_AR5212_V4) && ...

Also, let's call it AR5K_SREV_AR5212_R4 because 4 is the revision, not
the version.

-- 
Regards,
Pavel Roskin

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31320 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0DQXCG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 19:02:06 -0400
Message-ID: <20100417190203.yyfsyoma1z40o4ko-cebfxv@webmail.spamcop.net>
Date: Sat, 17 Apr 2010 19:02:03 -0400
From: Pavel Roskin <proski@gnu.org>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: lrodriguez@atheros.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH] ath5k/ath9k: Fix 64 bits TSF reads
References: <1271369246-6892-1-git-send-email-benoit.papillault@free.fr>
	<1271452384.16507.16.camel@mj> <4BC9B75E.9070005@free.fr>
In-Reply-To: <4BC9B75E.9070005@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Benoit PAPILLAULT <benoit.papillault@free.fr>:

> You are considering rollover here, but the TSF can make big jumps as
> well (in case of IBSS merges). This later case can only be handled by
> the above code, to my knowledge. I am seeking consistency first and
> optimization next, not the opposite.

OK, I didn't realize that.  Then I'm fine with your patch.  Sorry for  
the noise.

-- 
Regards,
Pavel Roskin

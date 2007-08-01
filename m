Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754121AbXHAR0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 13:26:50 -0400
Date: Wed, 1 Aug 2007 10:26:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
Message-Id: <20070801102615.c8f7d1b9.akpm@linux-foundation.org>
In-Reply-To: <46B066C9.9030100@googlemail.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<46B066C9.9030100@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 01 Aug 2007 12:56:09 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> Andrew Morton wrote:
> ...
> > - git-wireless is back.  It is still a >3MB diff, and appears to compile.
> > 
> ...
> 
> allmodconfig on UML 
> 
> ...
> 
> 
> In file included from drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:48:
> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_pio.h: In function 'bcm43xx_pio_write':
> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_pio.h:97: error: implicit declaration of function 'mmiowb'
> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c: In function 'bcm43xx_init':
> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:4051: warning: label 'err_dfs_exit' defined but not used
> make[4]: *** [drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.o] Error 1
> make[3]: *** [drivers/net/wireless/bcm43xx-mac80211] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> make: *** Waiting for unfinished jobs....
> 

(cc linux-wireless)

Probably Kconfig troubles again.

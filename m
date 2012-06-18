Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:43051 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751658Ab2FRGGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 02:06:23 -0400
Message-ID: <4FDEC547.1080701@xenotime.net> (sfid-20120618_080626_893269_2B11C36E)
Date: Sun, 17 Jun 2012 23:05:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Ouyang <ilhebe999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: make moduels tx.c error
References: <loom.20120617T234255-222@post.gmane.org>
In-Reply-To: <loom.20120617T234255-222@post.gmane.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2012 02:45 PM, Ouyang wrote:

>  Anyone can tell me how to figure this problem? I do not have much experience on
> linux kernel compiling.
> make modules
> make[1]: Nothing to be done for `all'.
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC [M]  net/mac80211/tx.o
> net/mac80211/tx.c: In function ‘ieee80211_tx’:
> net/mac80211/tx.c:1327:2: error: implicit declaration of function
> ‘ieee80211_tx_prepare’ [-W
> net/mac80211/tx.c: At top level:
> net/mac80211/tx.c:1601:1: error: conflicting types for ‘ieee80211_tx_prepare’
> net/mac80211/tx.c:1327:16: note: previous implicit declaration of
> ‘ieee80211_tx_prepare’ was
> net/mac80211/tx.c: In function ‘ieee80211_tx_prepare’:
> net/mac80211/tx.c:1643:7: warning: passing argument 1 of
> ‘__ieee80211_parse_tx_radiotap’ fro
> net/mac80211/tx.c:1516:13: note: expected ‘struct sk_buff *’ but argument is of
> type ‘struct
> net/mac80211/tx.c:1643:7: error: too many arguments to function
> ‘__ieee80211_parse_tx_radiot
> net/mac80211/tx.c:1516:13: note: declared here
> net/mac80211/tx.c: In function ‘ieee80211_monitor_start_xmit’:
> net/mac80211/tx.c:1790:2: error: implicit declaration of function
> ‘ieee80211_parse_tx_radiot
> cc1: some warnings being treated as errors
> make[2]: *** [net/mac80211/tx.o] Error 1
> make[1]: *** [net/mac80211] Error 2
> make: *** [net] Error 2



What kernel version is this?

What commands did you use to do the build?

thanks,

-- 
~Randy

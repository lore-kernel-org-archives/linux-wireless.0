Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:32248 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752818AbXJJMFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 08:05:50 -0400
From: bruno randolf <bruno@thinktube.com>
To: Markus Feldmann <feldmann_markus@gmx.de>
Subject: Re: Patch for Kernel and Ath5k
Date: Wed, 10 Oct 2007 20:59:04 +0900
Cc: linux-wireless@vger.kernel.org
References: <feieb9$nvg$1@sea.gmane.org>
In-Reply-To: <feieb9$nvg$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710102059.04990.bruno@thinktube.com> (sfid-20071010_130555_598904_86F2A940)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi markus!

use git!

git-clone 
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git

cd wireless-2.6

git checkout -b everything origin/everything

more info at:
http://linuxwireless.org/en/users/Drivers/ath5k#Hackingath5k

cheers,
bruno

On Wednesday 10 October 2007 20:51:06 Markus Feldmann wrote:
> Hi All,
>
> i tried to patch the Kernel to get the ATH5k Driver to work but without
> success.
>
> It seems i miss some scripts like check.sh
>
> Anybody knows how to get my Problem solved?
>
> bye Markus
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



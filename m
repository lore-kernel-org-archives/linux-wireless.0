Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:26277 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab1GRQAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 12:00:30 -0400
Message-ID: <4E24589B.5030303@gnu.org> (sfid-20110718_180036_797986_36F09B57)
Date: Mon, 18 Jul 2011 12:00:27 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: wy408 <wy52119514@163.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless cross compile
References: <loom.20110716T174804-267@post.gmane.org>
In-Reply-To: <loom.20110716T174804-267@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2011 11:54 AM, wy408 wrote:
> hi，everyone：
> i try to cross compile ath5k of compat-wireless for mips.
> i use
> make
> KLIB=/mnt/sda3/linux-kernel
> KLIB_BUILD=/mnt/sda3/linux-kernel
>
> but errors:
>
> config.mk:26:*****missing "endif"........
>
> i used compat-wireless 2.6.38 39 37 ,and error again.
>
> looking forward for your help.

There is not enough information in your post.  What is the version of 
the kernel you are compiling for?  What is the exact version of 
compat-wireless (the filename you downloaded)?  What is the version of make?

I tried to reproduce your problem with compat-wireless-2.6.39-1-sn 
compiling to Linux 2.6.24 with GNU make 3.8.1, but could not reproduce it.

-- 
Regards,
Pavel Roskin

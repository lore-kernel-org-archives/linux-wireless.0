Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28962 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010Ab0KJWhI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 17:37:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 14:36:56 -0800
Date: Wed, 10 Nov 2010 14:37:06 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Arnaud Lacombe <lacombar@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 00/44] Compat
Message-ID: <20101110223706.GJ4667@tux>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 09, 2010 at 06:19:42PM -0800, Arnaud Lacombe wrote:
> Hi Luis,
> 
> You will find in answer of this mail the first part of the compat upgrade I am
> using to support a network-oriented module on kernel from 2.6.15 to 2.6.36.
> 
> All this code is available on my repository on github:
> 
> https://github.com/lacombar/linux-compat.git local
> 
> This repository also contains the second part I will post later concerning a
> tentative to reduce namespace pollution when using the compat module. As it is
> mostly mechanical, I will start another thread with a single proof of concept
> patch and gather feedbacks :)
> 
> Comments welcome !

All in all, very sexy, thanks alot. Can you provide me with a
git pull url once you review the comments? If you can first

git fetch; git rebase origin/master

that would be great too.

Thanks a lot!

 Luis

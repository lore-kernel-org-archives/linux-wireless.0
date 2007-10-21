Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:31886 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXJUGnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 02:43:47 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1495470mue
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2007 23:43:45 -0700 (PDT)
Message-ID: <471AF51E.7050901@gmail.com> (sfid-20071021_074354_700471_6B830029)
Date: Sun, 21 Oct 2007 08:43:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
Subject: Re: [PATCH 0/2] ath5k: Further cleanups inside base.c
References: <20071021012030.GA5817@localhost.domain.invalid>
In-Reply-To: <20071021012030.GA5817@localhost.domain.invalid>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2007 03:20 AM, Nick Kossifidis wrote:
> A few more cleanups for base.c before i submit the rest of my fixes...
> 
> Q: Should we get rid of syctl stuff ? I mean user can only change 
> calibration interval (which is something tricky for users to play with) 
> and debug flags. Does anyone use this ? i mean we can put printks wherever
> we want, there's no need for this stuff IMHO (it comes from madwifi).

Agreed. And if really want it, we can make debug a module_param...

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35460 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1IGQi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 12:38:27 -0400
Subject: Re: [PATCH IGNORE AT YOUR PERIL] cfg80211: force interface
 combinations to be advertised
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <201109071832.48120.chunkeey@googlemail.com> (sfid-20110907_183334_604355_8A4A5491)
References: <1315412512.4002.10.camel@jlt3.sipsolutions.net>
	 <201109071832.48120.chunkeey@googlemail.com>
	 (sfid-20110907_183334_604355_8A4A5491)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 18:38:25 +0200
Message-ID: <1315413505.4002.11.camel@jlt3.sipsolutions.net> (sfid-20110907_183837_051285_24F639D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-07 at 18:32 +0200, Christian Lamparter wrote:

> no drivers? I thought I added the necessary bits
> in carl9170 shortly after the interface combinations
> patches were accepted?
> 
> commit df64962f7d74877624442c059e7878fdf7ec3c22
> Author: Christian Lamparter <chunkeey@googlemail.com>
> Date:   Sat May 14 02:42:38 2011 +0200
> 
>     carl9170: advertise interface combinations
> 
> Did I miss something there?

No, sorry, I just forgot, my mistake!

However, you were the only one, thanks for that!

johannes


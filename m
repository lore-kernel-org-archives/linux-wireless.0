Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from galaxy.systems.pipex.net ([62.241.162.31]:59915 "EHLO
	galaxy.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbXH2VXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 17:23:05 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] Fix breakage on WEP for cards that rely on =?utf-8?q?software=09decoding?=
Date: Wed, 29 Aug 2007 22:23:02 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200708282345.53016.adam@baker-net.org.uk> <1188389382.19891.12.camel@johannes.berg>
In-Reply-To: <1188389382.19891.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708292223.02321.linux@baker-net.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 29 August 2007 13:09, Johannes Berg wrote:

>
> I think this patch ought to fix it as well:
> http://johannes.sipsolutions.net/patches/kernel/all/2007-08-29-12:08/023-re
>work-hardware-crypto-flags.patch
>
> but it should probably have a few more changes.
>

I can confirm that with that patch WEP is working for me. Another user on the 
rt2x00 forum is also reporting success with it.

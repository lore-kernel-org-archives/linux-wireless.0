Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54035 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbYGWVW2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 17:22:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.26 b43 speed issue (redux) and new firmware drivers
Date: Wed, 23 Jul 2008 23:21:39 +0200
Cc: Gautam Iyer <gi1242+vger@stanford.edu>,
	linux-wireless@vger.kernel.org
References: <20080722193637.GC19885@stanford.edu> <48874C9D.2050900@lwfinger.net>
In-Reply-To: <48874C9D.2050900@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807232321.40096.mb@bu3sch.de> (sfid-20080723_232233_863889_F6D96585)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008 17:22:05 Larry Finger wrote:
> It is a fact of life that this kind of reverse engineering rarely will perform 
> better than the original driver. After all, if we make an exact copy, then we 
> repeat their mistakes. Any mistakes of ours have a small chance of improving 
> performance. Where we do improve on the original is in the error handling.

Well, there are parts in the b43 code that are subject to optimization.
The power adjustment code, for example. I have a patch in development for this,
but didn't work on it for quite some time.

-- 
Greetings Michael.

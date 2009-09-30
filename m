Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:32985 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbZI3VVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 17:21:37 -0400
Date: Thu, 1 Oct 2009 00:21:23 +0300
From: Jouni Malinen <j@w1.fi>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH]: nl80211: report age of scan results
Message-ID: <20090930212123.GA8616@jm.kir.nu>
References: <200909241055.51604.hs4233@mail.mn-solutions.de> <20090926081438.GA20788@jm.kir.nu> <200909280914.48847.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200909280914.48847.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2009 at 09:14:48AM +0200, Holger Schurig wrote:
> Oh, we can still easily change that to an absolute time, if you 
> prefer. It's not yet upstream, AFAIK.

I have had hard time trying to figure out which option I would really
prefer.. ;-) Since the patch is actually in wireless-testing.git now and
I do not have that strong opinion either way, it's fine to leave it in
as-is. If anyone gets interested enough in trying to figure out whether
scan results are from the time after the last scan (more exactly than
just guessing based on age), he/she can add that later and probably
using something like a sequence number for scan requests, etc.

-- 
Jouni Malinen                                            PGP id EFC895FA

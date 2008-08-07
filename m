Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38723 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbYHGQPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 12:15:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC: 2.6 patch] b43: the overdue firmware < 410 removal
Date: Thu, 7 Aug 2008 18:14:44 +0200
Cc: stefano.brivio@polimi.it, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20080806212304.GC1702@cs181140183.pp.htv.fi>
In-Reply-To: <20080806212304.GC1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808071814.45086.mb@bu3sch.de> (sfid-20080807_181515_577461_131381B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 August 2008 23:23:04 Adrian Bunk wrote:
> This patch contains the overdue removal of support for firmware
> revision < 410.

Well, I'm not sure if we should remove it now.
There are currently no problems with it, yet.
And people are still using it.

In my opinion, we should leave it in _until_ it causes me a major
headache (Because we'll have to switch to yet another (newer) firmware
or whatever). I will remove the old stuff then.

So well. Please leave the code untouched for now, as there are
_currently_ no problems with it and people are still using it.

-- 
Greetings Michael.

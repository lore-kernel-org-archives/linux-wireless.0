Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34463 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZKCOKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 09:10:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Christian Casteyde <casteyde.christian@free.fr>
Subject: Re: 2.6.32-rc5-git3: Reported regressions from 2.6.31
Date: Tue, 3 Nov 2009 15:10:33 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200911011628.34535.mb@bu3sch.de> <200911030043.26510.casteyde.christian@free.fr>
In-Reply-To: <200911030043.26510.casteyde.christian@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911031510.35837.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 November 2009 00:43:26 Christian Casteyde wrote:
> Nothing to mention: it seems to work, at least on my hardware.
> I got the Allocated bounce buffer log, and managed to boot without any error, 
> associate and access the web/ssh another computer (and didn't get any 
> kmemcheck error of course).

Ok, cool. Thanks a lot for testing. I'll resubmit this patch for inclusion later.

-- 
Greetings, Michael.

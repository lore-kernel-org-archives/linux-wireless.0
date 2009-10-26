Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50012 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbZJZTL0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 15:11:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.32-rc5-git3: Reported regressions from 2.6.31
Date: Mon, 26 Oct 2009 20:11:20 +0100
Cc: linux-wireless@vger.kernel.org,
	Christian Casteyde <casteyde.christian@free.fr>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <20091026185901.GH2792@tuxdriver.com>
In-Reply-To: <20091026185901.GH2792@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200910262011.22950.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 October 2009 19:59:02 John W. Linville wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14277
> > Subject		: Caught 8-bit read from freed memory in b43 driver at association
> > Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> > Date		: 2009-09-30 18:06 (27 days old)

Does this still trigger with a recent kernel (and thus recent memory debugging).
I'm still not convinced that this is a wireless bug.

-- 
Greetings, Michael.

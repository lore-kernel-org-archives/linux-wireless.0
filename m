Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2204 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYB2Qcm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 11:32:42 -0500
Date: Fri, 29 Feb 2008 11:26:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: David Miller <davem@davemloft.net>, gordonfarquharson@gmail.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: pull request: wireless-2.6 2008-02-27
Message-ID: <20080229162629.GB3234@tuxdriver.com> (sfid-20080229_163247_068642_2DE700B6)
References: <20080228014125.GI3078@tuxdriver.com> <97a0a9ac0802281321h6f302865j38a55c6f761dc14b@mail.gmail.com> <20080228.133008.228590007.davem@davemloft.net> <200802291316.59738.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200802291316.59738.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 29, 2008 at 01:16:59PM +0100, Michael Buesch wrote:

> I'm wondering if we can't simply pass a commandline parameter to file2alias
> that tells it whether we are crosscompiling. It should simply omit the sanity check

Sounds reasonable to me.

> in that case. Is there any easy and reliable way to find out whether we
> are crosscompiling from a makefile (I don't know the makefile core that much)?

Non-empty CROSS_COMPILE definition?

John
-- 
John W. Linville
linville@tuxdriver.com

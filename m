Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52938 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZIHSp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 14:45:27 -0400
Date: Tue, 8 Sep 2009 14:36:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: rt2x00: Hardcode TX ack timeout and consume time
Message-ID: <20090908183648.GE2617@tuxdriver.com>
References: <200909061514.23611.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200909061514.23611.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 06, 2009 at 03:14:23PM +0200, Ivo van Doorn wrote:
> rt2x00: Hardcode TX ack timeout and consume time

> John, this patch has not yet been confirmed by any of the above bugzilla reports,
> but I do think this should be merged as soon as possible to 2.6.31 since this issue
> has been marked as regression for quite some time now. :)

Well, given how late it is in the 2.6.31 cycle and the fact that this
problem has persisted for a while I think I'll just let this slip to
2.6.32 -- good enough?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

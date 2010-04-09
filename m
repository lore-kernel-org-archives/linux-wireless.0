Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22436 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab0DIVM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 17:12:29 -0400
Subject: Re: [PATCH 000/102] ath9k: add AR9003 support
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Fri, 09 Apr 2010 17:12:27 -0400
Message-Id: <1270847547.23853.56.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-08 at 15:25 -0400, Luis R. Rodriguez wrote:
> This series adds support for a new chipset family for the ath9k driver,
> the AR9003 harware family. This family of chipsets will includes 2-stream
> and 3-stream devices. We start off by supporting only 2-streams on both
> devices. Both the 2-stream and 3-stream devices are fully functional at
> this point. We have a few more items which we will iron out as part
> of future patches but we're sending this out so that we don't stall
> development on more cleanups/etc. Our delta is already quite large.

I hope everything went through checkpatch.pl and the result was checked
by sparse.  I tried to do it myself, but some patches need to be
updated.

Considering the huge amount of changes, maybe it would be better to send
the preparatory changes first, which don't refer to AR9003 in any way?
Those could be tested first.  Then the rest could be posted.

I like the idea of synchronization with the private HAL, as it means
that more eyeballs will be looking at the same code.  But I don't think
we should relax quality requirements.  If the private HAL is worse in
any aspect, even in a comment wording, the fix should go to the private
HAL, not to ath9k.

-- 
Regards,
Pavel Roskin

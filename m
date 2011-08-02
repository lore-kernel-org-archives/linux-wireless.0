Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36850 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1HBF7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 01:59:44 -0400
To: Brent Taylor <btaylor1@motorolasolutions.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ATH6KL lockup during init
References: <loom.20110726T174149-11@post.gmane.org>
	<loom.20110727T145019-705@post.gmane.org>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 02 Aug 2011 08:59:42 +0300
In-Reply-To: <loom.20110727T145019-705@post.gmane.org> (Brent Taylor's message of "Wed\, 27 Jul 2011 12\:51\:55 +0000 \(UTC\)")
Message-ID: <87hb60s69d.fsf@purkki.adurom.net> (sfid-20110802_075948_977371_DE2C9394)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brent Taylor <btaylor1@motorolasolutions.com> writes:

> Fixed ... realized that I was using the wrong firmware images. I was
> using an older image from AR6K_FW.3.0_RC.233.

Good that your issue was solved and thanks for letting us now. But
nevertheless the driver should not lockup in there's a problem with
firmware, ath6kl is definitely buggy here.

-- 
Kalle Valo

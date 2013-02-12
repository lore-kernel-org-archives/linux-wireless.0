Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50674 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933044Ab3BLN0q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 08:26:46 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac and IBSS
References: <1360604039.1559.44.camel@dcbw.foobar.com>
Date: Tue, 12 Feb 2013 15:26:45 +0200
In-Reply-To: <1360604039.1559.44.camel@dcbw.foobar.com> (Dan Williams's
	message of "Mon, 11 Feb 2013 11:33:59 -0600")
Message-ID: <87zjz9aciy.fsf@purkki.adurom.net> (sfid-20130212_142648_807110_8532E809)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> Had a bug report that a 4313 doesn't support IBSS mode, and dug around
> and found out that brcmsmac only supports STA mode.  Is that really true
> and there's no IBSS support in the smac driver?  Is that a firmware or
> driver limitation?  Seems odd that this got missed during the merge
> reviews as IBSS is pretty basic functionality that all the kernel wifi
> drivers have had for 5 or 7 years.

Are you saying that we should require Ad-Hoc mode from all drivers? I
hope not, I consider it as a niche feature. It also has it's own
problems, power save and encryption at least come to my mind.

-- 
Kalle Valo

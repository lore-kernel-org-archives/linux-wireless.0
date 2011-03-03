Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58670 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab1CCIOY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 03:14:24 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Pv3fz-0006li-0j
	for linux-wireless@vger.kernel.org; Thu, 03 Mar 2011 09:14:23 +0100
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 09:14:23 +0100
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 09:14:23 +0100
To: linux-wireless@vger.kernel.org
From: jpo234 <pommnitz@yahoo.com>
Subject: Re: Regulatory database improvements
Date: Thu, 3 Mar 2011 08:14:11 +0000 (UTC)
Message-ID: <loom.20110303T091059-822@post.gmane.org>
References: <AANLkTinzfBmpJ6-O=o-zi+oh9miLRo-UZUM=MhcnQmk=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@...> writes:

> If anyone has any input on this definition or would like some please
> start thinking about it and we can start talking about it. For details
> as to *why* we are doing this you can lok at the wiki page above or
> also the thread:

Luis,
we have an amplifier attached to one card and not on the other in our system.
The amplified card requires different regulatory constraints from the "normal"
one. So, what I'd like to see are per wiphy regulatory settings, not global ones.

Regards
  Joerg


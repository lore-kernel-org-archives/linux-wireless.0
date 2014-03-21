Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaCUPHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 11:07:15 -0400
Message-ID: <1395414428.4164.16.camel@jlt4.sipsolutions.net> (sfid-20140321_160720_677494_DE913CAA)
Subject: Re: [PATCH] ath10k: dont call csa_finish more than once
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 21 Mar 2014 16:07:08 +0100
In-Reply-To: <CA+BoTQk5RiFPjDGMSwFHd6GGt=x9M6QXGZcdENtMjQrDcORicg@mail.gmail.com> (sfid-20140321_155846_789375_330290D9)
References: <1395410520-26939-1-git-send-email-michal.kazior@tieto.com>
	 <1395411440.4164.15.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk5RiFPjDGMSwFHd6GGt=x9M6QXGZcdENtMjQrDcORicg@mail.gmail.com>
	 (sfid-20140321_155846_789375_330290D9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 15:58 +0100, Michal Kazior wrote:

> > Didn't we have this discussion on the hwsim patch before?
> 
> Oh. I'm not aware of the discussion. Probably missed it.

Or I got it wrong :)

> > I'd argue that if all drivers must track this, then the mac80211 API is
> > defective.
> 
> I can make this a mac80211 patch then?

Yeah I guess. What was the reason for this though? Here it's multi-vif?
Before I think we were talking about races?

johannes


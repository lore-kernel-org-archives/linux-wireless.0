Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47417 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbbIHTVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 15:21:47 -0400
Message-ID: <1441740103.1906.20.camel@sipsolutions.net> (sfid-20150908_212150_465749_18FF3B91)
Subject: Re: [PATCH] mac80211: Fix oops in OCB mode when receiving data when
 not joined
From: Johannes Berg <johannes@sipsolutions.net>
To: Bertold Van den Bergh <vandenbergh@bertold.org>
Cc: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>,
	linux-wireless@vger.kernel.org
Date: Tue, 08 Sep 2015 21:21:43 +0200
In-Reply-To: <CABm7fFM4aCJoFmHNFWyKALr1ZwTtxy2Hyte7TLX-TDa0eEswMw@mail.gmail.com> (sfid-20150908_211751_439857_E2E25676)
References: <1438781899-600-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
	 <1439456956.2114.8.camel@sipsolutions.net>
	 <1441728204.1906.18.camel@sipsolutions.net>
	 <CABm7fFM4aCJoFmHNFWyKALr1ZwTtxy2Hyte7TLX-TDa0eEswMw@mail.gmail.com>
	 (sfid-20150908_211751_439857_E2E25676)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-09-08 at 21:17 +0200, Bertold Van den Bergh wrote:
> Hello,
> 
> Sorry. I missed your previous email. I agree that your solution is
> better and cleaner.
> 
> Do you want me to submit a new patch?
> 

Yes, please do.

Thanks,
johannes

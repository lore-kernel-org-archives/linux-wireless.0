Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46331 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992544AbXCWToI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 15:44:08 -0400
Date: Fri, 23 Mar 2007 12:36:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: Re: [stable] [PATCH] fix information leak in wireless extensions on 64-bit platforms
Message-ID: <20070323193643.GY10574@sequoia.sous-sol.org>
References: <1174640787.3588.65.camel@johannes.berg> <1174657362.3366.6.camel@johannes.berg> <20070323154828.GA4671@bougret.hpl.hp.com> <1174665384.4470.0.camel@johannes.berg> <20070323161339.GA4713@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070323161339.GA4713@bougret.hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Jean Tourrilhes (jt@hpl.hp.com) wrote:
> 	It seems that the lifetime of each stable branch is measured
> in weeks (apart from 2.6.16),

That's not accurate (apart from the fact that months are made of weeks ;-)

~2.5 months
2.6.15.1  Jan 15  2006
2.6.15.7  Mar 28  2006

[skipping 2.6.16 since it's still going]

~2 months
2.6.17.1  Aug 22  2006
2.6.17.14 Oct 13  2006

~3 months
2.6.18.1  Oct 14 2006
2.6.18.8  Feb 23 2007

~3 months
2.6.19.1  Dec 11 2006
2.6.19.7  Mar  3 2007

And to reiterate the sentiments of others.  Security relevant bugs are
always of interest to the stable team as well as distros.

> 	The last thing is that I could not test those stuff myself,
> and the testing done for me was limited. I would be more confident if
> you were to give it a good beating before we push that into stable,
> because you know what to test.

That's useful info.  Have you had any luck (it looks pretty straight
forward)?

thanks,
-chris

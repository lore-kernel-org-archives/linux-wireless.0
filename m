Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:11289 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3GWHGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 03:06:50 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath: wil6210: Fix build error
Date: Tue, 23 Jul 2013 10:06:46 +0300
Message-ID: <6487488.19IqyPtizJ@lx-vladimir> (sfid-20130723_090653_483574_E91D7B92)
In-Reply-To: <20130722161554.GR17130@pogo>
References: <1374374808-12768-1-git-send-email-Larry.Finger@lwfinger.net> <1958736.oRuXAUfNGd@lx-vladimir> <20130722161554.GR17130@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, July 22, 2013 09:17:01 AM Luis R. Rodriguez wrote:
> On Sun, Jul 21, 2013 at 10:06:31AM +0300, Vladimir Kondratiev wrote:
> > Hmm, I have no warning for this with neither 3.10 nor 3.11 kernel version; but
> > patch is correct, and here is my
> > Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
> If you agree with a patch you don't say you Sign-off-by it as well,
> you say Acked-by. The Signed-off-by tag has a very specific meaning
> from development to a maintainer's hands, and its definition is on
> the Developer Certificate or Origin.
> 
> So in this case Acked-by is better.
> 
>   Luis

<drop most of CC>

I thought that I need to add Signed-off-by: as driver's maintainer, because
(quote Documentation/SubmittingPatches):
---
The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path.
---

This is similar to other maintainers adding its Signed-off-by:.
Or, is driver's maintainer an exception from the rule quoted above?

Thanks, Vladimir

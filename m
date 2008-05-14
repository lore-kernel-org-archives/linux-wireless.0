Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:27526 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYENTgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 15:36:03 -0400
Received: by wf-out-1314.google.com with SMTP id 27so33815wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2008 12:36:01 -0700 (PDT)
Subject: Re: [PATCH 5/5] b43: move the register write into
	radio2050_rfover_val
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200805142122.21635.mb@bu3sch.de>
References: <1210791396.6191.40.camel@brick>
	 <200805142122.21635.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 14 May 2008 12:35:57 -0700
Message-Id: <1210793758.6191.43.camel@brick> (sfid-20080514_213609_061251_8D4DC32D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-14 at 21:22 +0200, Michael Buesch wrote:
> On Wednesday 14 May 2008 20:56:36 Harvey Harrison wrote:
> > It is always called with the same dev, register value as the
> > b43_phy_write that wraps around it, make it return void
> > and move the register write into radio2050_rfover_val.
> 
> NACK to the whole 5 patches.
> See the list archives for an explanation.

Any particular reference for nacking 5/5?

While I respectfully disagree with you Re: 1-4 I can't make you take it.

But if you apply all 5, just look at the two files side-by-side and it
is much easier to follow with them applied.

Cheers,

Harvey


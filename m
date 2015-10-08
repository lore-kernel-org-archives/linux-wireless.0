Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47559 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbbJHJhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 05:37:09 -0400
Message-ID: <1444297027.2131.15.camel@sipsolutions.net> (sfid-20151008_113714_299669_95D95533)
Subject: Re: [PATCH] Remove superfluous header files
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 08 Oct 2015 11:37:07 +0200
In-Reply-To: <CABAco3Boow_64N33s=mSu0=K38D00a=OsoSQRJUoMN1_qP_3_A@mail.gmail.com> (sfid-20151004_230840_739242_6DE50D7D)
References: <CABAco3Boow_64N33s=mSu0=K38D00a=OsoSQRJUoMN1_qP_3_A@mail.gmail.com>
	 (sfid-20151004_230840_739242_6DE50D7D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-10-04 at 23:08 +0200, Ola Olsson wrote:
> if.h only contains if_nametoindex and the reverse.
> Lets remove the inclusion in the source files where
> these functions are not called.
> 
Applied, with updated subject.

Thanks!

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab2E3Wba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 18:31:30 -0400
Message-ID: <1338417129.8887.32.camel@dcbw.foobar.com> (sfid-20120531_003133_688127_C8E51C76)
Subject: Re: Master mode support in iwlagn?
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 30 May 2012 17:32:09 -0500
In-Reply-To: <1338381071.4511.13.camel@jlt3.sipsolutions.net>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be>
	 (sfid-20120530_140937_028561_351996E4) <1338381071.4511.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 14:31 +0200, Johannes Berg wrote:
> On Wed, 2012-05-30 at 14:09 +0200, Erwin Van de Velde wrote:
> > Dear all,
> > 
> > Are there any plans to add Master mode support to iwlagn? 
> 
> Depending on the device, it is (partially) supported as part of P2P/GO
> mode, but other than that there are no plans.

What's the list of devices that will support Master mode?  I recall that
3945 and 4965 never will.  And I assume anything 6xxx-based will get it.
But I was somewhat fuzzy on where the 5xxx series stand.

Dan


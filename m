Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51672 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab0DOUAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 16:00:15 -0400
Date: Thu, 15 Apr 2010 15:58:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: regression: soft lockup with ath9k on master-2010-04-14
Message-ID: <20100415195812.GC3020@tuxdriver.com>
References: <87pr20mrez.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87pr20mrez.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 15, 2010 at 10:44:52PM +0300, Kalle Valo wrote:
> Hello,
> 
> I just updated my laptop to latest wireless-testing and it everytime
> soft lockups few seconds after association.
> 
> I haven't updated wireless-testing for few days, so I can't say when
> this bug was introduced.

It might be useful to do a bisect.  If you choose to do that, you
might want to use wireless-next-2.6 instead, since that doesn't have
the occasional pulls from Linus that make bisecting wireless-testing
more painful.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

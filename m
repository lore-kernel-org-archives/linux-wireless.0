Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55106 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbaFYTaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 15:30:09 -0400
Date: Wed, 25 Jun 2014 15:18:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2014-06-24
Message-ID: <20140625191834.GG3445@tuxdriver.com> (sfid-20140625_213015_212667_603845DA)
References: <1403626964.10831.12.camel@jlt4.sipsolutions.net>
 <1403629678.10831.14.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403629678.10831.14.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2014 at 07:07:58PM +0200, Johannes Berg wrote:
> On Tue, 2014-06-24 at 18:22 +0200, Johannes Berg wrote:
> 
> > The biggest thing here is probably Arik's TDLS rework, beyond that we
> > have smaller improvements and features like David's scanning IE thing,
> 
> The latter seems to cause some issues with the ath9k multi-channel code,
> I didn't realize you'd merged that in.
> 
> The fix is not very difficult, so maybe you can just fix it when you
> merge? See commit eb6a61549f530f1cc435512df3799f656094ba83 for how all
> the other drivers were changed.

I don't see that commit ID anywhere...?

The merge seemed to be clean too.  Are we looking at the same things?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

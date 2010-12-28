Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab0L1JP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 04:15:27 -0500
Subject: Re: Patches submitted should apply to which git repository?
From: Johannes Berg <johannes@sipsolutions.net>
To: Naveenan <initramd@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTik9=r8tCouEg0joexH0_S9+WPfyDGDzq5fbMKOe@mail.gmail.com>
References: <AANLkTi=MhYzv54WvEwYGh15KC4LHyM=EVd-s+1BG8pBT@mail.gmail.com>
	 <1293526293.3526.1.camel@jlt3.sipsolutions.net>
	 <AANLkTik9=r8tCouEg0joexH0_S9+WPfyDGDzq5fbMKOe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 10:15:20 +0100
Message-ID: <1293527720.3526.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 03:12 -0600, Naveenan wrote:

> Would it be ok if I can send 2 different patches for both these 2 versions?
> 
> Unfortunately someone changed a line of code (that is a few lines
> before my patch
> but not related to it) in a recent commit to wireless-testing and this
> makes the patch
> not apply-able to both wireless-2.6 and wireless-next.
> 
> I would say that the fix is not a critical one would would be useful
> if applied to wireless-2.6 too.

Yes, if it's an important fix then you would have to send two versions.
Without seeing it, I can offer no advice on whether it is important
enough though.

johannes


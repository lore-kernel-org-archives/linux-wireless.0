Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45358 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbYIHVAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 17:00:34 -0400
Date: Mon, 8 Sep 2008 16:54:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <greg@kroah.com>, Michael Buesch <mb@bu3sch.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH V2] b43legacy: Fix failure in rate-adjustment mechanism
Message-ID: <20080908205459.GC24557@tuxdriver.com> (sfid-20080908_230037_772941_04A52C83)
References: <48c2fb5a.JqLELi8PJxjxmDaY%Larry.Finger@lwfinger.net> <200809070040.04300.mb@bu3sch.de> <20080908053155.GI4099@kroah.com> <48C55153.3070309@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48C55153.3070309@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2008 at 11:22:43AM -0500, Larry Finger wrote:
> Greg KH wrote:
>>
>> Bug fixes, not new features, it's pretty simple :)
>
> Just bug fixes, or does it have to be a regression?

As I understand it, the rule is more like "bug fixes that are committed
in the linux-2.6 tree".  Since Linus has become more strict about
requiring "regressions only" after the merge window, that effectively
enforces the "regressions only" rule on the -stable trees as well.

John
-- 
John W. Linville
linville@tuxdriver.com

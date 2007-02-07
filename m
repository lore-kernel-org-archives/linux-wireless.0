Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:43675 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965676AbXBGIRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 03:17:34 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HEhyZ-0000Sy-RF
	for linux-wireless@vger.kernel.org; Wed, 07 Feb 2007 03:16:23 -0500
Subject: Re: RFT bcm43xx: Really _GOOD_ news
From: Pavel Roskin <proski@gnu.org>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200702070303.40968.gene.heskett@verizon.net>
References: <45C8E64B.1050605@lwfinger.net>
	 <200702061848.00815.gene.heskett@verizon.net>
	 <45C95830.6040507@lwfinger.net>
	 <200702070303.40968.gene.heskett@verizon.net>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 03:17:30 -0500
Message-Id: <1170836250.11150.116.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-02-07 at 03:03 -0500, Gene Heskett wrote:

> And the 4318 is whats in my lappy.  What does it break?

Oh, please, let's stop such questions.  Does it really matter what some
knowingly wrong change does to particular hardware?  Just don't try the
old patch.  Just forget that it existed.  It's not going to the kernel.

Please try the new patch.  Ideally, measure speeds for various rates,
because it's the speed that the patch is supposed to improve.

If you have more questions of this kind, please make sure my personal
e-mail is not in CC.

-- 
Regards,
Pavel Roskin


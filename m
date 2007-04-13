Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:55840 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXDMA5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 20:57:13 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HcA3p-0000Yn-7h
	for linux-wireless@vger.kernel.org; Thu, 12 Apr 2007 20:54:45 -0400
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev 1  PHYs
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070413000950.GC3470@tuxdriver.com>
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
	 <20070413000950.GC3470@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 20:57:05 -0400
Message-Id: <1176425825.2588.58.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-04-12 at 20:09 -0400, John W. Linville wrote:
> I added this patch to the Fedora rawhide kernels, but our Fedora QA
> lead reports that he still has this crash:
> 
> 	http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233011
> 
> I had diagnosed this to be the same crash as this patch was supposed
> to address.  Was I in error?

I also observed the machine check with the current mb branch this
morning, although I didn't have a chance to capture it, so I wanted to
reported it later when I would have the details.

I was testing the patch on a G4 PowerMac.  I also have a G3 PowerMac
where I tested older versions, and I intend to test the current code on
it as well.

> Any thoughts?

Apparently more changes are needed.  I don't think the latest patch
needs to be reverted.

-- 
Regards,
Pavel Roskin


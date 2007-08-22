Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4085 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758224AbXHVRo5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 13:44:57 -0400
Date: Wed, 22 Aug 2007 13:18:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: ALERT: firmware change for b43
Message-ID: <20070822171805.GD2926@tuxdriver.com>
References: <46C89BF1.5060306@lwfinger.net> <20070822145257.GA2926@tuxdriver.com> <46CC5568.5000709@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46CC5568.5000709@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 22, 2007 at 10:25:28AM -0500, Larry Finger wrote:
> John W. Linville wrote:
> >On Sun, Aug 19, 2007 at 02:37:21PM -0500, Larry Finger wrote:
> >>Just in case you missed the details, the latest set of changes to b43 
> >>queued by Michael will require
> >>a new version of fwcutter, now called b43-fwcutter, and a new extraction 
> >>of your firmware.
> >
> >Is there a tarball available for download, as with bcm43xx-fwcutter?
> >It would be handy for packaging.
> 
> The new code is in the svn repository; however, a tarball would not be a 
> problem. Is source sufficient, or would you want an executable?

Source would be fine, equivalent to what is here:

	http://download.berlios.de/bcm43xx/bcm43xx-fwcutter-006.tar.bz2

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:45946 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759264AbXHVPZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 11:25:34 -0400
Message-ID: <46CC5568.5000709@lwfinger.net>
Date: Wed, 22 Aug 2007 10:25:28 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: ALERT: firmware change for b43
References: <46C89BF1.5060306@lwfinger.net> <20070822145257.GA2926@tuxdriver.com>
In-Reply-To: <20070822145257.GA2926@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sun, Aug 19, 2007 at 02:37:21PM -0500, Larry Finger wrote:
>> Just in case you missed the details, the latest set of changes to b43 queued by Michael will require
>> a new version of fwcutter, now called b43-fwcutter, and a new extraction of your firmware.
> 
> Is there a tarball available for download, as with bcm43xx-fwcutter?
> It would be handy for packaging.

The new code is in the svn repository; however, a tarball would not be a problem. Is source 
sufficient, or would you want an executable?

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30892 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbYL1V2I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 16:28:08 -0500
Subject: Re: status of at76-usb driver
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Claudio <der.claudio@aon.at>, linux-wireless@vger.kernel.org,
	Greg KH <gregkh@suse.de>
In-Reply-To: <87fxk8o2g0.fsf@litku.valot.fi>
References: <1230411118.4956956ecb911@webmail.aon.at>
	 <87fxk8o2g0.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Sun, 28 Dec 2008 16:28:03 -0500
Message-Id: <1230499683.25726.4.camel@dv> (sfid-20081228_222814_879299_4F3C46F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-12-28 at 15:26 +0200, Kalle Valo wrote:

> Also I'm going to rename the mac80211 port to something else for just
> to avoid the confusion with the original driver. Last thing I want to
> see is having two in-tree drivers with identical names.

I asked to rename the driver that was imported into the staging tree,
but my request was ignored.  I guess nobody really cares about the name
conflict.  I'll appreciate if we avoid further renames.  Once the
mac80211 port is working properly, it should be included in to the next
kernel release, and the driver from the staging tree should be removed
in the same kernel release.

-- 
Regards,
Pavel Roskin

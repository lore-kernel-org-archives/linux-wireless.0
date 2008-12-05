Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:34690 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbYLEP60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 10:58:26 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54usb: fix usb_kill_urb hang with slub_debug=P
Date: Fri, 5 Dec 2008 16:58:22 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-usb@vger.kernel.org, gregkh@suse.de,
	linux-kernel@vger.kernel.org
References: <200812051547.45790.chunkeey@web.de> <49394541.30404@lwfinger.net>
In-Reply-To: <49394541.30404@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812051658.23452.chunkeey@web.de> (sfid-20081205_165847_501036_0FDB83EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 05 December 2008 16:14:09 Larry Finger wrote:
> Christian Lamparter wrote:
> > This patch fixes a problem identified by Johannes Berg.
> > 
> > It looks like this is a classic case of "use-after-freed". 
> > A module which should reproduce the problem on
> > any other USB device can be found right here:
> > http://kerneltrap.org/mailarchive/linux-usb/2008/12/4/4317064
 
> I didn't find either the code nor a link to it in the above link. What did I miss?
> 
Sorry... kerneltrap doesn't like attachments.

http://marc.info/?l=linux-usb&m=122843263217096&w=2
has it.

Regards, 
	Chr

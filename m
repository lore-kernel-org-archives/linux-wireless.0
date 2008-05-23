Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3099 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYEWO3g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 10:29:36 -0400
Date: Fri, 23 May 2008 09:54:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH 00/51] iwlwifi driver 05/23 updates
Message-ID: <20080523135416.GA19379@tuxdriver.com> (sfid-20080523_162940_083152_19011E4C)
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com> <1211510742.7814.121.camel@debian.sh.intel.com> <20080523123204.GA12575@tuxdriver.com> <200805231526.27110.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805231526.27110.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 23, 2008 at 03:26:27PM +0200, Holger Schurig wrote:
> > It should be fine as-is, especially since you sent each as a
> > reply to the previous.
> 
> However, sending LOTS of patches via this way looks funny in 
> several e-mail clients. Here's an example with KMail:

That is true.  OTOH, sending them as individual messages (or as replies
to a single "0/N" message) can cause them to arrive out of order.

In most cases patches sent as a group need to be applied in a certain
order.  In many cases they will fail to apply, and in others they
might apply out of order but not be "bisectable" out of order.

IMHO it is a lot easier to deal with the "funny looking" mailbox
window than to deal with the issues caused by misordered patches.

John
-- 
John W. Linville
linville@tuxdriver.com

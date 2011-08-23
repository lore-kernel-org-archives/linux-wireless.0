Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40559 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755813Ab1HWUOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 16:14:16 -0400
Date: Tue, 23 Aug 2011 13:12:28 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] brcmsmac fixes and driver cleanup
Message-ID: <20110823201228.GC25977@kroah.com> (sfid-20110823_221420_276723_638E5DF3)
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1314101640-4229-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2011 at 02:13:52PM +0200, Arend van Spriel wrote:
> With 3.1 kernel the crc8 and cordic library modules are available in the
> staging tree. The brcmsmac driver now uses them. Some small fixes have
> been made and the driver is made to work on the Sparc platform.
> 
> This series applies to staging-next and depends on the following patch set:
> 
> Message-ID: <1313415267-5264-1-git-send-email-arend@broadcom.com>

All applied.

That's everything that you have pending, right?  Anything I miss?

thanks,

greg k-h

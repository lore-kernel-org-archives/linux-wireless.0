Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49844 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab1HWUKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 16:10:23 -0400
Date: Tue, 23 Aug 2011 13:09:16 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/15] staging: brcm80211: big-endian support and cleanup
Message-ID: <20110823200916.GB25977@kroah.com> (sfid-20110823_221030_399751_745A66BC)
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 15, 2011 at 03:34:12PM +0200, Arend van Spriel wrote:
> This patch series fixes several issues found on big-endian platform (Sparc,
> PowerPC, and MIPS) and some changes to code specific to broadcom MIPS
> platforms. Other patches are cleanup items to get rid of void pointer
> usage in the drivers.
> 
> This series applies to staging-next and depends on the following patch set:
> 
> Message-ID: <1313156101-16817-1-git-send-email-arend@broadcom.com>

All applied, thanks,

greg k-h

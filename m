Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34861 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755909Ab1JEUuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 16:50:14 -0400
Date: Wed, 5 Oct 2011 13:47:05 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/15] staging: brcm80211: cleanup fullmac structs and
 softmac srom lookup
Message-ID: <20111005204705.GA2467@kroah.com> (sfid-20111005_225018_603533_5C832DA5)
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 05, 2011 at 03:19:59PM +0200, Arend van Spriel wrote:
> This series addresses more community feedback items received on mainline
> patch (v2) posted August 25, 2011. The driver structures in brcmfmac could
> do with some tidying and in the brcmsmac variables loaded from srom were
> accessed by string identifiers. This has been replaced by enumerated
> identifiers and the entries are stored in kernel standard linked list.
> 
> This series applies to staging-next and depends on the patch series posted
> on Oct 4, 2011 (see Message-ID below).
> 
> Message-ID: <1317763152-17607-1-git-send-email-arend@broadcom.com>

All applied, thanks.

greg k-h

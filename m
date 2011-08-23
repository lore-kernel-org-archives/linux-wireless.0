Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53152 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab1HWUI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 16:08:28 -0400
Date: Tue, 23 Aug 2011 13:07:39 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/14] staging: brcm80211: brcmfmac driver cleanup
Message-ID: <20110823200739.GA23339@kroah.com> (sfid-20110823_220831_682282_CAF9132F)
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2011 at 03:34:47PM +0200, Arend van Spriel wrote:
> Several cleanup patches to reduce code for the brcmfmac driver and
> get rid of a remaining checkpatch warning. The driver sources should
> be clear from checkpatch issue now.
> 
> This series applies to staging-next and depends on the following patch set:
> 
> Message-ID: <1312811946-16713-1-git-send-email-arend@broadcom.com>

All now applied, thanks.

greg k-h

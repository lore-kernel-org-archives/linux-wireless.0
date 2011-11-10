Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817Ab1KJPSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:18:13 -0500
Date: Thu, 10 Nov 2011 07:17:46 -0800
From: Greg KH <gregkh@suse.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
Subject: Re: [PATCH 3.1-stable] staging: brcm80211: fix for rate index in
 receive status
Message-ID: <20111110151746.GB29104@suse.de> (sfid-20111110_161836_103778_9C05FAC7)
References: <1320918514-5916-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1320918514-5916-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 10, 2011 at 10:48:34AM +0100, Arend van Spriel wrote:
> This fix resolves an issue on 5GHz as posted on LKML:
> 
> BUG: All network processes hang (brcmsmac/wpa_supplicant)
> ID: <20111018111422.GA1979@schottelius.org>

What are these tags for?  I've not seen them in kernel patches before.

> Cc: stable@kernel.org

Wrong address, please use stable@vger.kernel.org now.

> Reported-by: Nico Schottelius <nico-linux-20111017@schottelius.org>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Greg,
> 
> This change is in the mainline brcmsmac driver, but I do not have a commit
> message to refer to as we transitioned from staging to mainline in the last
> merge window. Can you process this patch without that info?

No, I need the git commit id of the patch that fixed this in Linus's
tree, if the files are different due to the move, that's fine, but I
still need this to reference.

greg k-h

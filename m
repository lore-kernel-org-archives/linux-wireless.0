Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:36762 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758952Ab1DZWsG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 18:48:06 -0400
Date: Tue, 26 Apr 2011 15:46:47 -0700
From: Greg KH <greg@kroah.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org, brudley@broadcom.com,
	henryp@broadcom.com, hharte@broadcom.com
Subject: Re: [PATCH 0/5 v2] staging: brcm80211: remove si sb utils dependency
 from brcmfmac
Message-ID: <20110426224647.GA1355@kroah.com> (sfid-20110427_004811_343854_09209606)
References: <1303785248-27420-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303785248-27420-1-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2011 at 07:34:03PM -0700, Franky Lin wrote:
> Hi Greg,
> 
> I fix the apply error issue of the rest 5 patches. The original path series
> intends to remove si and sb utility from broadcom fullmac driver.

That worked much better, thanks.

greg k-h

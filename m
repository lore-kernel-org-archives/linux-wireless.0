Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1HXXsx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 19:48:53 -0400
Date: Wed, 24 Aug 2011 16:47:32 -0700
From: Greg KH <gregkh@suse.de>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110824234732.GA19384@suse.de> (sfid-20110825_014856_748913_E6A43EDB)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <20110824225357.GA2224@suse.de>
 <20110824231746.GF5280@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110824231746.GF5280@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 04:17:46PM -0700, Henry Ptasinski wrote:
> Augh.  I included the wrong link.  Correct link:
> 
> http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211-v2.patch
> 
> (Note the '-v2'.)
> 
> Very sorry about that.

Ah, much better, nevermind about my comments.

It looks checkpatch clean to me, I'll leave it up to the wireless
network developers to review this now.  I have no objections to this
moving if they don't.

thanks,

greg k-h

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4873 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab1DUROC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 13:14:02 -0400
Subject: Re: [PATCH v3 1/3] staging: brcm80211: replaced WL_NONE with
 no_printk
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <op.vuasnofu3ri7v4@arend-laptop>
References: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
	 <1303383725-1440-2-git-send-email-rvossen@broadcom.com>
	 <1303403680.24766.55.camel@Joe-Laptop>  <op.vuasnofu3ri7v4@arend-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 10:14:00 -0700
Message-ID: <1303406040.24766.65.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-21 at 19:10 +0200, Arend van Spriel wrote:
> If you want to debug a specific source file you could do following in that  
> particular source file:
> #undef no_printk
> #define no_printk  printk
> Not sure whether that is the intended use here.

True, but that's entirely backwards
and not very sensible either.

For that you use pr_debug/dev_dbg/etc
and then add #define DEBUG.



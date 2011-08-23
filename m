Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46896 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755813Ab1HWUFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 16:05:31 -0400
Date: Tue, 23 Aug 2011 13:02:05 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 01/82] staging: brcm80211: fix compile error on non-x86
 archs since 3.0 kernel
Message-ID: <20110823200205.GB602@kroah.com> (sfid-20110823_220535_822884_782E9A1D)
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
 <1312811946-16713-2-git-send-email-arend@broadcom.com>
 <4E400EB6.5000508@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E400EB6.5000508@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 08, 2011 at 06:28:38PM +0200, Arend van Spriel wrote:
> On 08/08/2011 03:57 PM, Arend van Spriel wrote:
> >From: Arend Van Spriel<arend@broadcom.com>
> >
> >Since the arrival of kernel version 3.0 in the staging tree it
> >turns out compile error occurs for sparc64, powerpc, and arm
> >platforms. This patch fixes that issue.
> >
> 
> Hi Greg,
> 
> Actually, the error was also on MIPS which is enabled in Kconfig.
> Can this one also go to 3.1 ie. Linus' tree?

I'll queue it up there as well, thanks for pointing it out.

greg k-h

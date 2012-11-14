Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422641Ab2KNQGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 11:06:05 -0500
Date: Wed, 14 Nov 2012 10:05:59 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121114160559.GA18738@thinkpad-t410> (sfid-20121114_170610_599655_3A60834B)
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
 <50955ADB.9020703@broadcom.com>
 <20121104202549.GB24905@ubuntu-mba51>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121104202549.GB24905@ubuntu-mba51>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I've got v2 patches prepped with your request changes, which I'll send
as soon as I'm finished testing. I did have a question about one of your
requests though.

On Sun, Nov 04, 2012 at 09:25:49PM +0100, Seth Forshee wrote:
> On Sat, Nov 03, 2012 at 06:56:43PM +0100, Arend van Spriel wrote:
> > >   brcmsmac: Add module parameter for setting the debug level
> > 
> > I would prefer doing this through debugfs.

I mentioned this to you at the wireless summit. If this is moved to
debugfs it will not allow for setting the debug level at module load
time. If we leave it a module parameter it can still be set at runtime
via /sys/module/parameters/brcmsmac/debug, assuming BRCMDBG is enabled.
I currently don't have this change in my v2 patches, but if you still
want it changed to debugfs let me know and I'll take care of it.

Thanks,
Seth

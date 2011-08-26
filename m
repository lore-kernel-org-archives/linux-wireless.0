Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:27921 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566Ab1HZUBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 16:01:02 -0400
Date: Fri, 26 Aug 2011 16:00:57 -0400
From: Jason <linuxdriverproject@lakedaemon.net>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Howard Harte <hharte@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 00/14] staging: brcm80211: brcmfmac driver cleanup
Message-ID: <20110826200057.GM29321@titan.lakedaemon.net> (sfid-20110826_220106_940709_96BA816E)
References: <1313156101-16817-1-git-send-email-arend@broadcom.com> <CACna6rztueomzzas=hQjfj6htD=SHFhrtFPSqbviqVDwaihJ9w@mail.gmail.com> <4E4555AD.7040809@broadcom.com> <CACna6rx_d4btykdK7AMwFxeFMs_MxjHEHvR6coxaZkfqkQVafA@mail.gmail.com> <CACna6rzJWHP+EPy6bwQkLZnjxsL6TKfYnQ71Nq8myOjmeBPODg@mail.gmail.com> <20110826173159.GA4888@broadcom.com> <20110826173855.GL29321@titan.lakedaemon.net> <20110826174446.GE4888@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110826174446.GE4888@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 26, 2011 at 10:44:46AM -0700, Henry Ptasinski wrote:
> On Fri, Aug 26, 2011 at 10:38:55AM -0700, Jason wrote:
> > On Fri, Aug 26, 2011 at 10:31:59AM -0700, Henry Ptasinski wrote:
> > > A possibly better approach would be a device with a BCM4329 on the
> > > motherboard (e.g. table, phone, etc) that can run a relatively stock
> > > linux kernel.  However, I don't know of a specific platform at the
> > > moment to recommend.
> > 
> > Nexus One phone?
> 
> That's a possibility.  Are people running recent, relatively unmodified linux
> kernels on the Nexus One?  (Or you could backport brcmfmac to the Android
> version of the kernel, perhaps using compat-wireless).

folks run debian from the sdcard [1], a mainline kernel shouldn't be too
big of a stretch from there.  Especially if the purpose is for testing
wifi.  Don't need PM, GSM, display, 3D, etc for that.

Note, I haven't tried it yet, myself.  It's been on the _long_ list of
projects.  It would be higher on the list if brcmfmac supported all the
normal Linux features like monitor mode, AP mode, multiple-VAPs, etc.
Or, at least, was in mainline and would accept patches adding such
features... ;-)

hth,

Jason.

[1] http://www.irregular-expression.com/?p=30

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2206 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab1HZRo6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 13:44:58 -0400
Date: Fri, 26 Aug 2011 10:44:46 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: Jason <linuxdriverproject@lakedaemon.net>
cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Howard Harte" <hharte@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 00/14] staging: brcm80211: brcmfmac driver cleanup
Message-ID: <20110826174446.GE4888@broadcom.com> (sfid-20110826_194501_324973_3BFA9A1B)
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
 <CACna6rztueomzzas=hQjfj6htD=SHFhrtFPSqbviqVDwaihJ9w@mail.gmail.com>
 <4E4555AD.7040809@broadcom.com>
 <CACna6rx_d4btykdK7AMwFxeFMs_MxjHEHvR6coxaZkfqkQVafA@mail.gmail.com>
 <CACna6rzJWHP+EPy6bwQkLZnjxsL6TKfYnQ71Nq8myOjmeBPODg@mail.gmail.com>
 <20110826173159.GA4888@broadcom.com>
 <20110826173855.GL29321@titan.lakedaemon.net>
MIME-Version: 1.0
In-Reply-To: <20110826173855.GL29321@titan.lakedaemon.net>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 26, 2011 at 10:38:55AM -0700, Jason wrote:
> On Fri, Aug 26, 2011 at 10:31:59AM -0700, Henry Ptasinski wrote:
> > A possibly better approach would be a device with a BCM4329 on the
> > motherboard (e.g. table, phone, etc) that can run a relatively stock
> > linux kernel.  However, I don't know of a specific platform at the
> > moment to recommend.
> 
> Nexus One phone?

That's a possibility.  Are people running recent, relatively unmodified linux
kernels on the Nexus One?  (Or you could backport brcmfmac to the Android
version of the kernel, perhaps using compat-wireless).

- Henry



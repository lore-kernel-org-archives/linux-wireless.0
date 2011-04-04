Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:52027 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab1DDWzH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 18:55:07 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 15:54:42 -0700
Date: Mon, 4 Apr 2011 15:56:43 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Vipin Mehta <Vipin.Mehta@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"greg@kroah.com" <greg@kroah.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Naveen Singh <Naveen.Singh@Atheros.com>
Subject: Re: [PATCH 34/34] ath6kl: remove the HTC raw interface
Message-ID: <20110404225248.GA30856@vmehta-desktop>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
 <1301446591-15236-35-git-send-email-lrodriguez@atheros.com>
 <35B17FE5076C7040809188FBE7913F984316D17DDC@SC1EXMB-MBCL.global.atheros.com>
 <AANLkTi=_T-f7e0dGC05mACjGFD86VP+MULZsfXinTXkq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTi=_T-f7e0dGC05mACjGFD86VP+MULZsfXinTXkq@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 31, 2011 at 11:03:50AM -0700, Luis R. Rodriguez wrote:
> On Thu, Mar 31, 2011 at 9:50 AM, Vipin Mehta <Vipin.Mehta@atheros.com> wrote:
> > The raw HTC support is required for the tools used on the manufacturing floor
> > For module calibration. Without this code, the driver and the hardware
> > cannot be shipped. I suggest we keep this code until we add the support for
> > nl80211 test command interface and migrate the tools to use the new interface.
> 
> Vipin, so you NACK the patch -- that's fine. Greg please drop this
> one. Vipin, when do you plan on adding the nl80211 test command
> support? The API already exists. I'll remind you that this is a
> blocker for getting this out of staging.
> 
>   Luis
Greg,
  Can you apply the rest of the changes from patch 0 through 33 in
this series if you are satisfied with them. We have more patches coming
but are currently waiting for you to apply the existing ones.

Thanks,
Vipin

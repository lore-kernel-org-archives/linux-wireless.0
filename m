Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:46493 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1DEHic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 03:38:32 -0400
Date: Mon, 4 Apr 2011 23:00:22 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Vipin Mehta <Vipin.Mehta@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Naveen Singh <Naveen.Singh@atheros.com>
Subject: Re: [PATCH 34/34] ath6kl: remove the HTC raw interface
Message-ID: <20110405060022.GA7464@kroah.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
 <1301446591-15236-35-git-send-email-lrodriguez@atheros.com>
 <35B17FE5076C7040809188FBE7913F984316D17DDC@SC1EXMB-MBCL.global.atheros.com>
 <AANLkTi=_T-f7e0dGC05mACjGFD86VP+MULZsfXinTXkq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
> one.

Dropped.

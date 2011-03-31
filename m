Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49811 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1CaSEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 14:04:11 -0400
Received: by qyk7 with SMTP id 7so3739783qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 11:04:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <35B17FE5076C7040809188FBE7913F984316D17DDC@SC1EXMB-MBCL.global.atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
 <1301446591-15236-35-git-send-email-lrodriguez@atheros.com> <35B17FE5076C7040809188FBE7913F984316D17DDC@SC1EXMB-MBCL.global.atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 31 Mar 2011 11:03:50 -0700
Message-ID: <AANLkTi=_T-f7e0dGC05mACjGFD86VP+MULZsfXinTXkq@mail.gmail.com>
Subject: Re: [PATCH 34/34] ath6kl: remove the HTC raw interface
To: Vipin Mehta <Vipin.Mehta@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"greg@kroah.com" <greg@kroah.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Naveen Singh <Naveen.Singh@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 31, 2011 at 9:50 AM, Vipin Mehta <Vipin.Mehta@atheros.com> wrote:
> The raw HTC support is required for the tools used on the manufacturing floor
> For module calibration. Without this code, the driver and the hardware
> cannot be shipped. I suggest we keep this code until we add the support for
> nl80211 test command interface and migrate the tools to use the new interface.

Vipin, so you NACK the patch -- that's fine. Greg please drop this
one. Vipin, when do you plan on adding the nl80211 test command
support? The API already exists. I'll remind you that this is a
blocker for getting this out of staging.

  Luis

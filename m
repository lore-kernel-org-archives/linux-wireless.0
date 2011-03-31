Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63089 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256Ab1CaQuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:50:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 09:50:20 -0700
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"greg@kroah.com" <greg@kroah.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Naveen Singh <Naveen.Singh@Atheros.com>
Date: Thu, 31 Mar 2011 09:50:42 -0700
Subject: RE: [PATCH 34/34] ath6kl: remove the HTC raw interface
Message-ID: <35B17FE5076C7040809188FBE7913F984316D17DDC@SC1EXMB-MBCL.global.atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
 <1301446591-15236-35-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-35-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----Original Message-----
From: Luis Rodriguez 
Sent: Tuesday, March 29, 2011 5:57 PM
To: greg@kroah.com
Cc: devel@linuxdriverproject.org; linux-wireless@vger.kernel.org; Vipin Mehta; Naveen Singh; Luis Rodriguez
Subject: [PATCH 34/34] ath6kl: remove the HTC raw interface

This uses ioctl, if this is required it should be replaced
with the nl80211 test command interface.




The raw HTC support is required for the tools used on the manufacturing floor
For module calibration. Without this code, the driver and the hardware
cannot be shipped. I suggest we keep this code until we add the support for
nl80211 test command interface and migrate the tools to use the new interface.

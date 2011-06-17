Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4164 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab1FQRLo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 13:11:44 -0400
Date: Fri, 17 Jun 2011 10:11:33 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Thomas Novin" <thomas@xyz.pp.se>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>, mcgrof@gmail.com
Subject: Re: disagrees about version of symbol
Message-ID: <20110617171132.GC2200@broadcom.com> (sfid-20110617_191157_975085_21927A10)
References: <BANLkTi=AP7JKfuL3K+GzB_GhOw=hYmEGpg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <BANLkTi=AP7JKfuL3K+GzB_GhOw=hYmEGpg@mail.gmail.com>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 17, 2011 at 12:54:28AM -0700, Thomas Novin wrote:
> Hi
> 
> I was going to test the brcm80211 driver to replace the wl driver on
> my gfs laptop to support a BCM4727 chip.
> 
> After doing scripts/driver-select, choosing that driver, make, make
> install, make unload and them modprobe brcm80211 I get this:

So you're using compat-wireless, correct?  What version of compat-wireless
and kernel?

After the "make unload", are cfg80211 and mac80211 actually unloaded?

> Jun 17 09:43:41 jennie-laptop kernel: [ 5418.241140] brcm80211: module
> is from the staging directory, the quality is unknown, you have been
> warned.
> Jun 17 09:43:41 jennie-laptop kernel: [ 5418.241989] brcm80211:
> disagrees about version of symbol ieee80211_free_hw

You might have the original mac80211 loaded, not the updated one.

- Henry


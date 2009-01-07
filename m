Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9663 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbZAGQoG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 11:44:06 -0500
Subject: Re: [wireless-testing] iwl3945: ErrMsgs "MAC is in deep sleep!"
	and "mac80211-phy0: failed to set key" and unused variables in build-log
From: reinette chatre <reinette.chatre@intel.com>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <2d0a357f0901070301ha31f71cma046bdc9590f0e33@mail.gmail.com>
References: <2d0a357f0901070301ha31f71cma046bdc9590f0e33@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 08:45:41 -0800
Message-Id: <1231346741.13053.7.camel@rc-desk> (sfid-20090107_174410_234838_B99E52E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-01-07 at 03:01 -0800, Sedat Dilek wrote:

> # tail -f /var/log/kern.log
> [...]
> Jan  7 11:37:58 seduxbox kernel: wlan0: deauthenticating by local
> choice (reason=3)
> Jan  7 11:37:58 seduxbox kernel: iwl3945 0000:10:00.0: MAC is in deep sleep!
> Jan  7 11:37:58 seduxbox kernel: iwl3945 0000:10:00.0: MAC is in deep sleep!
> Jan  7 11:37:58 seduxbox kernel: iwl3945 0000:10:00.0: MAC is in deep sleep!
> [...]
> 
> Q: What does this mean in general "MAC is in deep sleep!"? Has this
> something to do with power-management?
> 

We are aware of this problem (see
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1834 ) and
are working on a fix for 3945.

I'll look into the build warnings - than you for the report.

Reinette



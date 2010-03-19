Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0CSGFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 02:05:13 -0400
Subject: Re:
From: reinette chatre <reinette.chatre@intel.com>
To: Vasil Lalov <vasil.lalov@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <f39b508c1003170613g5a8754a2kc9e15075c16f499b@mail.gmail.com>
References: <f39b508c1003170613g5a8754a2kc9e15075c16f499b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 23:05:12 -0700
Message-ID: <1268978712.2446.1757.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 06:13 -0700, Vasil Lalov wrote:

> The error messages in dmesg:
> 
> iwlagn 0000:0c:00.0: Microcode SW error detected.  Restarting 0x2000000.
> [40595.037808] iwlagn 0000:0c:00.0: Start IWL Error Log Dump:
> [40595.037814] iwlagn 0000:0c:00.0: Status: 0x000212E4, count: 5
> [40595.037945] iwlagn 0000:0c:00.0: Desc
> Time       data1      data2      line
> [40595.037954] iwlagn 0000:0c:00.0: NMI_INTERRUPT_WDG            (#04)
> 3570070946 0x00000002 0x07030000 3664

[...]

> [40595.101312] iwlagn 0000:0c:00.0: Stopping AGG while state not ON or starting
> [40595.101318] iwlagn 0000:0c:00.0: queue number out of range: 0, must
> be 10 to 19
> [40595.101340] iwlagn 0000:0c:00.0: Stopping AGG while state not ON or starting
> [40595.101343] iwlagn 0000:0c:00.0: queue number out of range: 0, must
> be 10 to 19

This looks similar to https://bugzilla.kernel.org/show_bug.cgi?id=15374
- could you please update your kernel to 2.6.33 and try the patches
attached to that bug report?

Reinette



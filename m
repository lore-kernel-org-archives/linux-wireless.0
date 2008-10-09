Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38246 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbYJIUg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 16:36:58 -0400
Subject: Re: iwl3945 randomly hangs system on boot
From: reinette chatre <reinette.chatre@intel.com>
To: Yotam Benshalom <benshalom@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1223569509.7723.10.camel@ubuntu>
References: <1223569509.7723.10.camel@ubuntu>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 13:35:01 -0700
Message-Id: <1223584501.1628.79.camel@rc-desk> (sfid-20081009_223703_605605_06D516B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-10-09 at 17:25 +0100, Yotam Benshalom wrote:
> Hello!
> 
> I am not a developer of any kind, but I wanted to draw your attention to
> the problem described here:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/263059
> The latest iwl3945 driver combined with 2.6.27.2 and above kernel hangs
> the system randomly on boot. Removing the firmware or blacklisting the
> driver solves it. Is there a workaround? Is this a driver issue or
> kernel issue? And is this problem known and being taken care of?
> 

Could you please enable the module to be loaded at boot with debugging
enabled (debug=0x43fff) and submit a new bug at
http://www.intellinuxwireless.org/bugzilla/ with the output when the
system freezes?

Thank you

Reinette


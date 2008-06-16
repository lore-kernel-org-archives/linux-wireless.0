Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYFPBkg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 21:40:36 -0400
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only
	with	disable_hw_scan=1
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1213368350.9783.7.camel@localhost.localdomain>
References: <484FF375.8010002@gmail.com>
	 <1213237561.7814.688.camel@debian.sh.intel.com>
	 <48511B1D.4010901@gmail.com>
	 <1213282970.6589.9.camel@localhost.localdomain>
	 <1213322439.7814.770.camel@debian.sh.intel.com>
	 <1213368350.9783.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 09:40:11 +0800
Message-Id: <1213580411.7814.877.camel@debian.sh.intel.com> (sfid-20080616_093315_575304_4F787DE1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-13 at 10:45 -0400, Dan Williams wrote:
> SW rfkill doesn't necessarily kill the device.  Input-only switches
> (like Fn+F5 on thinkpads for exampel) aren't handled by the kernel
> rfkill system and thus something in userspace needs to handle them
> instead.  It's probably worth checking the radio state when the event
> comes in and only if the radio isn't already disabled, then set tx
> power off.

OK. That makes sense.

Thanks,
-yi


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:64715 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZCLX5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 19:57:31 -0400
Received: by fxm24 with SMTP id 24so2423747fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 16:57:27 -0700 (PDT)
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1236897665.3911.8.camel@abhi-desktop>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
	 <1236821360.9581.78.camel@maxim-laptop>
	 <1236824994.7177.3.camel@maxim-laptop>  <1236880246.13699.17.camel@rc-desk>
	 <1236892879.30325.7.camel@maxim-laptop>
	 <1236897665.3911.8.camel@abhi-desktop>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 01:56:58 +0200
Message-Id: <1236902218.13039.8.camel@maxim-laptop> (sfid-20090313_005734_926052_5FEE3C86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-12 at 15:41 -0700, Abhijeet Kolekar wrote:
> Can you try the attached patch for rate scaling?

Just tried it.
It doesn't make things worse, but nether better.

It seems that I can fully control speeds using iwconfig, and when speed
drop, I see that there.

Now speed dropped to 48 Mbits/s raw or 2.9 Mbytes/s real upload.
But I can reset it to 54Mbits/s, then set speed to auto, then it will be
3.1 for a while, then drops again.

On the other hand speed is quite stable, it drops once in a while due to
scanning for few seconds to about 2.2 Mbytes/s, then restores itself
again.

This was more or less the same as without this patch (I also use hw
scanning now).


Anyway, it is almost perfect. All I need to do it to set speed to
54Mbits/s manually.

Best regards and thanks,
	Maxim Levitsky


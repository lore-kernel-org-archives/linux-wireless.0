Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50145 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531Ab0DPUzx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 16:55:53 -0400
Subject: Re: [PATCH 2/2] iwmc3200wifi: check sparse endianness annotations
From: Pavel Roskin <proski@gnu.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1271381324-21044-2-git-send-email-yi.zhu@intel.com>
References: <1271381324-21044-1-git-send-email-yi.zhu@intel.com>
	 <1271381324-21044-2-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Fri, 16 Apr 2010 16:55:50 -0400
Message-Id: <1271451350.16507.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 09:28 +0800, Zhu Yi wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> Add -D__CHECK_ENDIAN__ to driver ccflags so that sparse will
> always check endianness by default.

I believe it's wrong.  I would be fine with enabling __CHECK_ENDIAN__
for the whole kernel by default (perhaps with an option to disable it).
But there is no reason why some particular drivers need that check more
than the rest of the kernel.

-- 
Regards,
Pavel Roskin

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29720 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbYBYBuv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 20:50:51 -0500
Subject: Re: can't bring up wlan0
From: Zhu Yi <yi.zhu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080223153142.da9fc4e4.akpm@linux-foundation.org>
References: <20080223153142.da9fc4e4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 09:51:52 +0800
Message-Id: <1203904312.3082.156.camel@debian.sh.intel.com> (sfid-20080225_015055_677878_A6FF590E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2008-02-23 at 15:31 -0800, Andrew Morton wrote:
> t61p:/home/akpm# ifconfig wlan0 up
> SIOCSIFFLAGS: No such device

Did dmesg tell something about missing firmware?

Thanks,
-yi


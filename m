Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33718 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab3B1ITk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 03:19:40 -0500
Message-ID: <1362039502.23194.81.camel@cumari.coelho.fi> (sfid-20130228_091958_355859_AAEA7DDA)
Subject: Re: [PATCH 3/5] wl1251: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
From: Luciano Coelho <coelho@ti.com>
To: Li Fei <fei.li@intel.com>
CC: <linville@tuxdriver.com>, <wfp5p@virginia.edu>,
	<gregkh@linuxfoundation.org>, <notasas@gmail.com>, <rjw@sisk.pl>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <chuansheng.liu@intel.com>
Date: Thu, 28 Feb 2013 10:18:22 +0200
In-Reply-To: <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-28 at 15:51 +0800, Li Fei wrote:
> Even in failed case of pm_runtime_get_sync, the usage_count
> is incremented. In order to keep the usage_count with correct
> value and runtime power management to behave correctly, call
> pm_runtime_put(_sync) in such case.
> 
> Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---

Looks good.  I'll apply this via my tree.

Thanks!

--
Luca.


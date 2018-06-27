Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54782 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932145AbeF0GSk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 02:18:40 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: kbuild test robot <lkp@intel.com>
CC: "kbuild-all@01.org" <kbuild-all@01.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>
Subject: RE: [EXT] Re: [PATCH 2/2] mwifiex: restructure rx_reorder_tbl_lock
 usage
Date: Wed, 27 Jun 2018 06:18:23 +0000
Message-ID: <6930dd64dc8548a981f937584e7d6904@SC-EXCH02.marvell.com> (sfid-20180627_081843_954530_6A2BCC67)
References: <1529919775-21274-2-git-send-email-gbhat@marvell.com>
 <201806261421.RVECoUXA%fengguang.wu@intel.com>
In-Reply-To: <201806261421.RVECoUXA%fengguang.wu@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>    drivers/net//wireless/marvell/mwifiex/11n_rxreorder.c:155:16: note:
> 'flags' was declared here
>      unsigned long flags;
>                    ^~~~~
We did fix the warning and have upstreamed v2 of the patch.

Thanks,
Ganapathi

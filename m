Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3690 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYHQPcd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 11:32:33 -0400
Date: Sun, 17 Aug 2008 11:02:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Mirco Tischler <mt-ml@gmx.de>,
	Leonid Podolny <leonidp.lists@gmail.com>,
	linux-kernel@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	IvDoorn@gmail.com
Subject: Re: CPU load after killing iwlagn with RF kill switch
Message-ID: <20080817150242.GA23926@tuxdriver.com> (sfid-20080817_173248_029400_0B6FDBEC)
References: <48A5EC02.4070303@gmail.com> <20080817035921.4d35ae0e@mtlp.12thdimension> <1ba2fa240808170004p63b76db1l1fdfb1cf1cb41636@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240808170004p63b76db1l1fdfb1cf1cb41636@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 17, 2008 at 10:04:12AM +0300, Tomas Winkler wrote:

> There is gap in current rfkill implementation that we didn't close
> yet.  There were also few patches that were not signed by Intel and
> are apparently wrong.

Can you be more specific?  Do you know which patches are wrong (even
if you don't know how to fix them)?

John
-- 
John W. Linville
linville@tuxdriver.com

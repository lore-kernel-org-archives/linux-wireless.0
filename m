Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3221 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbXERScv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 14:32:51 -0400
Date: Fri, 18 May 2007 14:13:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Eugene Teo <eteo@redhat.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
	linux-wireless@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/fw.c: fix use-before-check
Message-ID: <20070518181355.GD3492@tuxdriver.com>
References: <464DDD29.3000009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <464DDD29.3000009@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 19, 2007 at 01:06:49AM +0800, Eugene Teo wrote:
> NULL checks should be performed before the dereference.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Eugene Teo <eteo@redhat.com>

This does not apply against 2.6.22-rc1.  Please rediff and repost.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com

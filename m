Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40304 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZFASp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 14:45:27 -0400
Date: Mon, 1 Jun 2009 14:34:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4 v2] libertas: implement function init/shutdown
	commands for SD8688
Message-ID: <20090601183453.GD3386@tuxdriver.com>
References: <1243465413-4997-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243465413-4997-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 04:03:33PM -0700, Bing Zhao wrote:
> SD8688 is a WLAN/Bluetooth combo chip and both functions are supported
> in a single firmware image. FUNC_INIT and FUNC_SHUTDOWN commands are
> implemented to utilize the multiple function feature.
> 
> When SD8688 card is inserted, the firmware image should be downloaded
> only once through either WLAN function (Libertas driver) or Bluetooth
> function (Bluetooth driver).
> 
> This patch adds function init/shutdown for SD8688 WLAN function only.
> 
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

I already merged the 5/19 version.  Could you send a patch rebased
on wireless-testing?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

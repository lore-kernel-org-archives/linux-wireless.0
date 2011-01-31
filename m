Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58571 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1AaUAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 15:00:23 -0500
Date: Mon, 31 Jan 2011 14:52:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>,
	Marek Vasut <marek.vasut@gmail.com>, dcbw@redhat.com
Subject: Re: [PATCH 0/3] libertas_spi fixes
Message-ID: <20110131195227.GB3065@tuxdriver.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 21, 2011 at 10:44:47PM +0200, Vasily Khoruzhick wrote:
> This series attempts to fix libertas_spi bug (it calls functions that
> may sleep from atomic context) and add pm support to libertas_spi.
> Tested on Zipit Z2 device.

Are the libertas folks OK with this series?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33078 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaCEQu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 11:50:27 -0500
Date: Wed, 5 Mar 2014 17:50:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: linville@tuxdriver.com, pali.rohar@gmail.com,
	david.gnedt@davizone.at, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:net:wireless:ti:wl1251: Fixed Sparse invalid
 assignment warning
Message-ID: <20140305165020.GA17056@Nokia-N900> (sfid-20140305_175051_151157_FCEDDE0D)
References: <1393921132-15950-1-git-send-email-surendra.tux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393921132-15950-1-git-send-email-surendra.tux@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue 2014-03-04 00:18:52, Surendra Patil wrote:
> Sparse warns about invalid assignment in
> drivers/net/wireless/ti/wl1251/cmd.c:451:42: warning: invalid assignment: |=
> drivers/net/wireless/ti/wl1251/cmd.c:451:42:    left side has type restricted __le16
> drivers/net/wireless/ti/wl1251/cmd.c:451:42:    right side has type int
> Hence type converted right side to __le16.
> 
> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>

Acked-by: Pavel MMachek <pavel@ucw.cz>

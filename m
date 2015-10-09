Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48109 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374AbbJISYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 14:24:25 -0400
Date: Fri, 9 Oct 2015 21:23:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: typo in
 WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
Message-ID: <20151009182326.GV7340@mwanda> (sfid-20151009_202446_038857_1B8801A1)
References: <20151008184724.GA11027@kroah.com>
 <1444414747-8049-1-git-send-email-kholmanskikh.s.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444414747-8049-1-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 09, 2015 at 09:19:07PM +0300, Stanislav Kholmanskikh wrote:
> Looking at the code, it seems that "MEMROY" in the config option
> name is a typo. It should be "MEMORY" instead.
> 
> Changed the config option name accordingly.
> 
> Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>

Just delete it and delete -DWILC_NORMAL_ALLOC as well.

regards,
dan carpenter


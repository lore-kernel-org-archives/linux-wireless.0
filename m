Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45320 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbbFVJRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 05:17:43 -0400
Date: Mon, 22 Jun 2015 12:17:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dean Lee <dean.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com,
	chris.park@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: modify type casting warning
Message-ID: <20150622091734.GW28762@mwanda> (sfid-20150622_111746_205336_F97F59C2)
References: <1434437164-4345-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434437164-4345-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This silences the warning but really the warnings indicate real bugs
which need to be fixed.  Silencing these warnings makes the bugs harder
to find so it is a step in the wrong direction.

Change SendConfigPkt() so that drvHandler is a pointer.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in

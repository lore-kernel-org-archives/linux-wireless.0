Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47784 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbbHJSjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 14:39:22 -0400
Date: Mon, 10 Aug 2015 21:38:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chandra Gorentla <csgorentla@gmail.com>
Cc: rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH] staging: wilc100: Remove pointer and integer comparision
Message-ID: <20150810183856.GM5180@mwanda> (sfid-20150810_203926_783548_86046C20)
References: <1439133602-9654-1-git-send-email-csgorentla@gmail.com>
 <20150810093943.GI5180@mwanda>
 <20150810152943.GA12993@gcs-HP-Compaq-nx6320>
 <20150810155614.GK5096@mwanda>
 <20150810174034.GA14776@gcs-HP-Compaq-nx6320>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150810174034.GA14776@gcs-HP-Compaq-nx6320>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Warnings are not a bad thing they are a valuable marker to let us know
which code is broken.  If we just silence the warning in the laziest
possible way then we are throwing away valuable information.  It's
better to leave the warning there so that the next person can fix it
properly.

If you want to leave the code as-is that is absolutely fine with me, but
don't remove the warning until someone can look at this a bit carefully.

regards,
dan carpenter


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f193.google.com ([209.85.192.193]:35432 "EHLO
	mail-pd0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965062AbbHKPU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2015 11:20:56 -0400
Date: Tue, 11 Aug 2015 20:37:59 +0530
From: Chandra Gorentla <csgorentla@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com,
	csgorentla@gmail.com
Subject: Re: [PATCH] staging: wilc100: Remove pointer and integer comparision
Message-ID: <20150811150759.GA16442@gcs-HP-Compaq-nx6320> (sfid-20150811_172119_614087_2E46F655)
References: <1439133602-9654-1-git-send-email-csgorentla@gmail.com>
 <20150810093943.GI5180@mwanda>
 <20150810152943.GA12993@gcs-HP-Compaq-nx6320>
 <20150810155614.GK5096@mwanda>
 <20150810174034.GA14776@gcs-HP-Compaq-nx6320>
 <20150810183856.GM5180@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150810183856.GM5180@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2015 at 09:38:56PM +0300, Dan Carpenter wrote:
> Warnings are not a bad thing they are a valuable marker to let us know
> which code is broken.  If we just silence the warning in the laziest
> possible way then we are throwing away valuable information.  It's
> better to leave the warning there so that the next person can fix it
> properly.
> 
> If you want to leave the code as-is that is absolutely fine with me, but
> don't remove the warning until someone can look at this a bit carefully.
> 
> regards,
> dan carpenter
> 

Thank you.

It looks like it needs more knowledge of wireless networking to
conclude if there was any problem and to fix if any problem exists.

I will come back to this problem in near future, if the error was
still observed then.

chandra

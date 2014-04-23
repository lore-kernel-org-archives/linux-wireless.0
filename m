Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39415 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaDWVr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 17:47:59 -0400
Date: Thu, 24 Apr 2014 00:47:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mwifiex: add firmware dump feature for PCIe
Message-ID: <20140423214747.GA4963@mwanda> (sfid-20140423_234806_340874_87EE0709)
References: <20140423143029.GA28228@mwanda>
 <477F20668A386D41ADCC57781B1F70430F70A2A9EA@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70A2A9EA@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 23, 2014 at 02:37:09PM -0700, Bing Zhao wrote:
> 
> AFAIK, the debugfs or sysfs cannot store/hold the files we retrieve
> from firmware at the scene. We write fw_dump files to rootfs so that
> the files are stored even if the system reboots due to hung_task
> timeout. 

Ah.  Gotcha.

regards,
dan carpenter


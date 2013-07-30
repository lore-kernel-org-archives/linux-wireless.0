Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:60072 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391Ab3G3NlT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 09:41:19 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Dan Carpenter' <dan.carpenter@oracle.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 30 Jul 2013 06:38:58 -0700
Subject: RE: mwifiex: handle driver initialization error paths
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951035636378@SC-VEXCH1.marvell.com> (sfid-20130730_154122_703192_CA2D7965)
In-Reply-To: <20130729144754.GA7601@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

>Hello Amitkumar Karwar,

>The patch 6b41f941d7cd: "mwifiex: handle driver initialization error 
>paths" from Jul 22, 2013, leads to the following warning:
>"drivers/net/wireless/mwifiex/main.c:533 mwifiex_fw_dpc()
>	 warn: 'adapter' was already freed."

Thanks for pointing this out. We will fix this regression issue.

Regards,
Amitkumar Karwar


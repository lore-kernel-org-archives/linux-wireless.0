Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:39696 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab1IWL6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 07:58:25 -0400
Received: by bkbzv15 with SMTP id zv15so4790057bkb.18
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 04:58:22 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: correct fw_status structure for 8 sta
 support in AP-mode
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316674326-4873-1-git-send-email-arik@wizery.com>
References: <1316674326-4873-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 14:58:18 +0300
Message-ID: <1316779098.2157.739.camel@cumari> (sfid-20110923_135828_694713_6C408879)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-22 at 09:52 +0300, Arik Nemtsov wrote: 
> Fix an erroneous labeling of array boundaries in the fw_status structure.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied both.  Thanks, Arik!

-- 
Cheers,
Luca.


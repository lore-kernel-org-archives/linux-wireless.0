Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:11734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYKQU4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 15:56:47 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2215695fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 12:56:46 -0800 (PST)
Message-ID: <4921DA8A.1000804@gmail.com> (sfid-20081117_215654_697654_96263F10)
Date: Mon, 17 Nov 2008 22:56:42 +0200
From: Valentin Manea <valentin.manea@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: config.mk regresion
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

   I've noticed that at least the last 2 nightlies for compat 
wireless(for 16th and the 17th) have the older part for the Intel AGN 
driver - so there is no way to build it. Currently the lines in 
config.mk are like this:

> CONFIG_IWLWIFI=m
> 
> CONFIG_IWLCORE=m
> CONFIG_IWL3945=m
> CONFIG_IWL4965=m
> CONFIG_IWL4965_HT=y

and they should be something like
CONFIG_IWLAGN=m
CONFIG_IWL4965=y
etc.

I know that at some point - less than a month a go(sorry - but I'm not quite sure how to dig through the git logs) the config was fine.

Best Regards,
Valentin



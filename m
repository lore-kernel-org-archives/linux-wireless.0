Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:49924 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab0BCJhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 04:37:50 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: add fake hw scan handler
Date: Wed, 3 Feb 2010 10:36:19 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com
References: <1265188851.29119.84.camel@johannes.local>
In-Reply-To: <1265188851.29119.84.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002031036.19942.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +	for (i = 0; i < req->n_channels; i++)
> +		printk(KERN_DEBUG "hwsim can chan %d\n",
> +			req->channels[i]->center_freq);

Should that be

  printk(KERN_DEBUG "hwsim scan chan %d\n",
                           ^
  (missing s)

???

-- 
http://www.holgerschurig.de

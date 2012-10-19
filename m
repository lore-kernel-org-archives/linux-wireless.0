Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48901 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533Ab2JSLYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 07:24:35 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so279574oag.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2012 04:24:35 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 19 Oct 2012 19:24:34 +0800
Message-ID: <CAEFj987U5sjk-ze3Tn8bh3OFD8j=p8=ffDS8zwtWO=R3UMi6iw@mail.gmail.com> (sfid-20121019_132438_924793_F9833FAD)
Subject: Re: [PATCHv2 2/2] mac80211: implement set_mcast_rate() callback
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: ordex@autistici.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Antonio

> +	memcpy(sdata->vif.bss_conf.mcast_rate, &rate, sizeof(rate));

I think that the second argument should be "rate" instead of "&rate".

---
Chun-Yeow

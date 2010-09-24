Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60723 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0IXRqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 13:46:42 -0400
Received: by pvg2 with SMTP id 2so741594pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 10:46:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285272430-9617-1-git-send-email-greearb@candelatech.com>
References: <1285272430-9617-1-git-send-email-greearb@candelatech.com>
Date: Fri, 24 Sep 2010 20:46:41 +0300
Message-ID: <AANLkTi=n9GDjiBxiS0cen2objz+BO9CeC-Uy5c6hVWhS@mail.gmail.com>
Subject: Re: [PATCH v2] This allows ath5k to support virtual STA and AP interfaces.
From: Nick Kossifidis <mickflemm@gmail.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/23  <greearb@candelatech.com>:
> From: Ben Greear <greearb@candelatech.com>
>
> +#define ATH5K_VIF_MAX  2048

This is too much !!! 2048 interfaces with a total of 4 beacon buffers
40 rx buffers and 200 tx buffers ? Has anyone tested this ?

Also think about embedded devices, we don't want to waste memory like this...

>+       struct ieee80211_vif *vifs[ATH5K_VIF_MAX];

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

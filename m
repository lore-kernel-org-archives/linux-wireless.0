Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtitmf2.realsil.com.cn ([60.250.210.236]:1113 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZKPFa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 00:30:57 -0500
Message-ID: <4B00E270.1020307@realsil.com.cn>
Date: Mon, 16 Nov 2009 13:26:08 +0800
From: david woo <xinhua_wu@realsil.com.cn>
MIME-Version: 1.0
To: saurav barik <saurav.barik@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: trying to add rfkill support to realtek driver for rtl8192e
References: <26b26d180911152013p22564134vf5cbd94d3bac7b@mail.gmail.com>
In-Reply-To: <26b26d180911152013p22564134vf5cbd94d3bac7b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

saurav barik 写道:
> Hi,
> 
> I am trying to implement rfkill support for realtek driver for rtl8192e.
> The realtek driver we are using is very much similar to the one in
> kernel 2.6.31.5(linux-2.6.31.5/drivers/staging/rtl8192su).
> In order to use "wiphy_rfkill_set_hw_state", I need "struct wiphy"
> which in turn is a part of "ieee80211_hw" structure.
> However ieee80211_hw is not used in our driver.
> Is the usage of 80211_hw is obsolete?
  No, 
  the rtl8192e need to be updated to support ieee80211_hw in order to be 
  merged to Linux kernel main tree.
> Without having the above structure how can I use the rfkill interface?
  The rtl8192e Linux drive structure is similar with the ipw2200, maybe you 
  can refer to the "struct wiphy" support within it.

> 
> Anybody aware of this, please share some pointers.
> 
> Thanks for your time.
> 
> Regards,
> Saurav
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> ------Please consider the environment before printing this e-mail. 
> 
> 
> 


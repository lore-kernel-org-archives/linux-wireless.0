Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:48685 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3KDPea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 10:34:30 -0500
Received: by mail-oa0-f53.google.com with SMTP id n12so7150099oag.26
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 07:34:29 -0800 (PST)
Message-ID: <5277BE84.7020808@lwfinger.net> (sfid-20131104_163435_320661_22032FDD)
Date: Mon, 04 Nov 2013 09:34:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	alexandre.f.demers@gmail.com, linville@tuxdriver.com
Subject: Re: r92su: status and will it be merged anytime soon?
References: <5277AC85.5050104@gmail.com>
In-Reply-To: <5277AC85.5050104@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2013 08:17 AM, Xose Vazquez Perez wrote:
> Christian Lamparter wrote:
>
>> The issue with r92su is: The driver is ready, but it's fundamentally
>                                        ^^^^^^^^
>> incompatible with the rtlwifi framework and mac80211.
>
> _anything_ is better than a staging driver.
>
> There are distributions that don't build staging drivers.

As a result, they force their users to build out-of-tree drivers!

> So, please, replace and delete staging/rtl8712 with r92su.

You seem not to understand. Any new wireless driver that does not use mac80211 
*must* go into staging. AFAIK, that rule is absolute, and r92su cannot go into 
the regular wireless tree.

If you do not like having drivers for RTL8192SU in staging, then write one that 
uses mac80211. You have access to as much information about the chips as anyone 
outside Realtek. They have no interest in doing the mac80211 version, and I have 
many other tasks with higher priority.

Larry



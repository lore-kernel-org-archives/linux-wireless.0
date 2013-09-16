Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:42423 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3IPTLb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 15:11:31 -0400
Received: by mail-lb0-f172.google.com with SMTP id x18so4644168lbi.3
        for <linux-wireless@vger.kernel.org>; Mon, 16 Sep 2013 12:11:29 -0700 (PDT)
Message-ID: <523757E0.6010903@cogentembedded.com> (sfid-20130916_211143_176986_9CCF4121)
Date: Mon, 16 Sep 2013 23:11:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 5/8 V2] [PATCH 5/7: rtlwifi: Fix smatch warning in pci.c
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net> <1379357722-17687-6-git-send-email-Larry.Finger@lwfinger.net> <5237562D.4080509@cogentembedded.com>
In-Reply-To: <5237562D.4080509@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/16/2013 11:04 PM, Sergei Shtylyov wrote:

>> Smatch reports the following:
>>    CHECK   drivers/net/wireless/rtlwifi/pci.c
>> drivers/net/wireless/rtlwifi/pci.c:739 _rtl_pci_rx_interrupt() warn:
>> assigning (-98) to unsigned variable 'stats.noise'

>> This variable is not used and is removed.

>     It is not a variable but a structure field initializer you're removing.

    Meant to also write that your subject is spoiled but forgot. :-)

WBR, Sergei


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43851 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1A0Qub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 11:50:31 -0500
Received: by fxm20 with SMTP id 20so2343307fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 08:50:29 -0800 (PST)
Message-ID: <4D41A275.2070704@lwfinger.net>
Date: Thu, 27 Jan 2011 10:51:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Mini PCIeWiFi card not detected in non-mini adapter
References: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com>
In-Reply-To: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2011 10:37 AM, Rafał Miłecki wrote:
> I've received mini PCIe adapter to PCIe x1 slot to test notebook cards
> inserted into PC.  Unfortunately after inserting my Broadcom card to
> it, it is not detected in "lspci" at all.
> 
> My WiFi card used to work in "native" slot inside notebook. So if
> anything is broken, that would be PCIe x1 slot on motherboard or
> adapter itself. I've tested V and GND pins in my PCIe x1 slot, all
> work fine. I'll try get some other WiFi cards, to test my adapter
> tomorrow.
> 
> However, maybe you have heard about some problems with such a
> adapters? Can there be sth preventing my card from being detected,
> visible?

Does the adapter show up as a new bridge in lspci or in dmesg?

Larry

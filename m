Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49290 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab1HZVfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 17:35:00 -0400
Received: by yie30 with SMTP id 30so1952748yie.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 14:34:59 -0700 (PDT)
Message-ID: <4E581180.9020609@lwfinger.net> (sfid-20110826_233511_124734_0E1C857E)
Date: Fri, 26 Aug 2011 16:34:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
	Maxime Vincent <maxime.vince@gmail.com>,
	Darren <dmbtech@gmail.com>
Subject: Re: [wireless-next][PATCH 0/3][ANNOUNCE] b43 the first Linux driver
 supporting HT-PHY (BCM4331)!
References: <1314384081-3460-1-git-send-email-zajec5@gmail.com> <20110826232731.3ade9956@milhouse>
In-Reply-To: <20110826232731.3ade9956@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/26/2011 04:27 PM, Michael Büsch wrote:
> On Fri, 26 Aug 2011 20:41:18 +0200
> Rafał Miłecki<zajec5@gmail.com>  wrote:
>
>> After improving DMA (the important patch for BCM4331 is my one) we can finally
>> enable support for HT-PHY.
>
> I'd really like to thank you guys for your great work on the driver.
> You made some really significant improvements to the driver in the last few
> months and thus ported b43 over to the latest and greatest broadcom
> wireless devices. Things looked messy with only legacy G-PHY support,
> but then you guys appeared. ;) Thanks.

The "guys" are really only one guy, Rafał. His ability to convert ugly mmio 
dumps into code is remarkable.

Larry

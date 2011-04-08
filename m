Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44958 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1DHGwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 02:52:01 -0400
Received: by fxm17 with SMTP id 17so2145655fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 23:52:00 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Questions about rt2800usb
Date: Fri, 8 Apr 2011 08:50:10 +0200
Cc: Jett Chen <jett_chen@ralinktech.com>,
	wireless <linux-wireless@vger.kernel.org>
References: <4D9E316E.4000908@lwfinger.net>
In-Reply-To: <4D9E316E.4000908@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104080850.11086.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

Am Donnerstag, 7. April 2011 schrieb Larry Finger:
> I know from experience that the staging driver rt82860sta has been replaced by 
> rt2800pci and I plan to push a patch deleting the driver from staging.

rt2800pci is quite stable already (at least for me). So removing rt2860sta
would be ok I think.

> It appears that rt2870sta has been replaced by rt2800usb. Is that correct? If 
> so, I will also include the deletion of that driver from staging in the patch.
> 
> I noticed that rt2870sta includes a few USB IDs not found in rt2800usb, namely:
> 
> 0x2001:0x3c09, 0x2001:0x3c0a, and 0x2019:0xed14.
> 
> Any reasons why these should not be included in rt2800usb?

I'm not quite sure about rt2800usb. It's still a bit immature in my opinion.

On the other hand, as long as people just use the staging driver instead of
reporting bugs for rt2800usb that situation won't change that fast.

Helmut

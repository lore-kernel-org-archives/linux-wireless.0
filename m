Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61333 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab1JDNxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 09:53:30 -0400
Received: by mail-yw0-f46.google.com with SMTP id 5so487490ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 06:53:30 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adrian Chadd <adrian@freebsd.org>
Subject: Re: [patch] fix the definition of AR9170_PHY_REG_CURRENT_RSSI
Date: Tue, 4 Oct 2011 15:47:50 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAJ-VmomAP-LZdVkh1snpsTOxU18yPMxXut=KzjTwP+AkN9XidQ@mail.gmail.com>
In-Reply-To: <CAJ-VmomAP-LZdVkh1snpsTOxU18yPMxXut=KzjTwP+AkN9XidQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201110041547.50175.chunkeey@googlemail.com> (sfid-20111004_155333_640722_63A5EB5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, October 04, 2011 02:30:51 AM Adrian Chadd wrote:
> Hi Christian,
> 
> Although it currently isn't used anywhere, I thought it'd be
> worthwhile fixing the definition of AR9170_PHY_REG_CURRENT_RSSI.
> It's at AR_PHY(271) rather than AR_PHY(263).
> 
> The carl9170 driver may also suffer the same problem. The older
> version I have lying around here doesn't seem to use
> AR9170_PHY_REG_CURRENT_RSSI anywhere but it is defined.
> 
> Thanks,
	Adrian
I have to thank you :). I've commited your change and I hope
I get around to restore carl9170fw.git tree anytime "soon".

BTW, do you have any technical docs about the phy as well?
Or how do you know about the mix-up?

Regards,
	Christian

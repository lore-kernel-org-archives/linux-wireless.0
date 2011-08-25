Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45991 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1HYRYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 13:24:09 -0400
Received: by ewy4 with SMTP id 4so1118248ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 10:24:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4e55750c.GPPIrbNLynUMWY/U%Larry.Finger@lwfinger.net>
References: <4e55750c.GPPIrbNLynUMWY/U%Larry.Finger@lwfinger.net>
Date: Thu, 25 Aug 2011 19:24:08 +0200
Message-ID: <CACna6ryVB3yTj7rQbSdCqrw-9WtaPZedM7Ug6JV0iTDQQOv=Sw@mail.gmail.com> (sfid-20110825_192414_510367_16DB2F77)
Subject: Re: [RFC/RFT] b43: Relax requirement for descriptors to be in the DMA zone
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/25 Larry Finger <Larry.Finger@lwfinger.net>:
> When 64-bit DMA was first used, there were problems with the
> BCM4311 (14e4:4311). The problem was "fixed" by using the GFP_DMA
> flag in the allocation of coherent ring descriptor memory.
>
> The original problem is now believed to have been due to bugs in
> the 64-bit DMA implementation in the rest of the kernel, and that
> those bugs have been fixed. Accordingly, the requirement for the
> descriptors to be in the DMA zone is relaxed.

Larry, it is not clear to me from the commit message: did you test
that patch with your 14e4:4311?

-- 
Rafał

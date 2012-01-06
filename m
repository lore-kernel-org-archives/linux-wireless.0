Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9818 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574Ab2AFKb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 05:31:59 -0500
Message-ID: <4F06CD8F.50204@qca.qualcomm.com> (sfid-20120106_113204_970019_C635D00A)
Date: Fri, 6 Jan 2012 12:31:43 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Daniel Smith <viscous.liquid@gmail.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: AR6002 support in ath6kl driver
References: <CADGLRPkBk+FhPSoEf=dK+W+yx1FS0HP3tkjv6BxPHQ5ZmCRg-A@mail.gmail.com>
In-Reply-To: <CADGLRPkBk+FhPSoEf=dK+W+yx1FS0HP3tkjv6BxPHQ5ZmCRg-A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On 12/28/2011 11:01 PM, Daniel Smith wrote:

> So I have recently been asked to begin supporting an AR6002
> platform. Currently it is using the Atheros ar6000 (v 2.1.2) driver.
> I see that the ar6kl driver only supports the AR6003 and was
> wondering if there was some technical reason that support for the
> AR6002 was dropped in the up-streaming process?

No other reason than lack of time and resources.

> If not, would AR6002 support be welcomed in the mainstream driver
> should I decide to attempt the endeavor of porting/adding into the
> ath6kl driver?

I would be happy to take AR6002 patches as long as they follow the style
used in ath6kl and are otherwise of good quality. I would recommend that
you first setup your own git tree for this and once you have something
working we can start discussing merging your changes to ath6kl.

> Finally, could I expect any support from the ath6kl
> developers troubleshooting issues that would inevitable arise along
> the way?

Based on my long email backlog I cannot provide anything than reviewing
patches and giving general comments. I simply don't have the time to
work on the details.

Kalle

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:35320 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1ISRNI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 13:13:08 -0400
Date: Mon, 19 Sep 2011 19:13:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
Cc: 'Larry Finger' <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	'LKML' <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= 3.1-rc6+ rtl8192se issue
Message-ID: <20110919171309.GB3271@gere.osrc.amd.com> (sfid-20110919_191312_725992_0CFB201A)
References: <20110915124406.GA14374@gere.osrc.amd.com>
 <4E721871.7040901@lwfinger.net>
 <20110916180323.GA1988@gere.osrc.amd.com>
 <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 12:43:45PM +0800, 李朝明 wrote:
> Dear sir:
> 
> 	Can you give me the screen pcitrue after crash again with ips = 0;
> or swlps=0 ips=0.

FWIW,

the box has been running stable a whole workday today with "swlps=0
ips=0" I'll run it only with "ips=0" tomorrow to try the reproduce the
sluggishness again.

Thanks.

-- 
Regards/Gruss,
Boris.

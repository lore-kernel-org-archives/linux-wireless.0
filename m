Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:59577 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1IWKdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 06:33:37 -0400
Date: Fri, 23 Sep 2011 12:33:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
Cc: 'Larry Finger' <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	'LKML' <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?= =?utf-8?B?5aSNOg==?=
 3.1-rc6+ rtl8192se issue
Message-ID: <20110923103339.GA26078@gere.osrc.amd.com> (sfid-20110923_123347_942905_278AF00F)
References: <20110915124406.GA14374@gere.osrc.amd.com>
 <4E721871.7040901@lwfinger.net>
 <20110916180323.GA1988@gere.osrc.amd.com>
 <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn>
 <20110921185816.GA2036@gere.osrc.amd.com>
 <791179BCE62F4954AB936E6CAC9CA977@realsil.com.cn>
 <4E7AAB8B.40900@lwfinger.net>
 <20110922075115.GA17640@liondog.tnic>
 <6452E68488784D0EA32E4BDF1B941EFB@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <6452E68488784D0EA32E4BDF1B941EFB@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 23, 2011 at 06:21:07PM +0800, 李朝明 wrote:
> Please set ips =0 and try again..

What does that mean?

I can trigger the grinding-to-a-halt reliably with "ips=0" - it only
takes a couple of hours of network traffic. Also, I don't want to try
the driver you sent me because the version in the kernel needs fixing
not some out-of-tree codebase.

So please clarify your request.

Thanks.

-- 
Regards/Gruss,
Boris.

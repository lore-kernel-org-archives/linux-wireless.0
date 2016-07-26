Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52266 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbcGZPQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2016 11:16:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	"Avinash Patil" <avinashp@quantenna.com>,
	Dmitrii Lebed <dlebed@quantenna.com>,
	"Sergei Maksimenko" <smaksimenko@quantenna.com>,
	Sergey Matyukevich <smatyukevich@quantenna.com>,
	Bindu Therthala <btherthala@quantenna.com>,
	Huizhao Wang <hwang@quantenna.com>,
	Kamlesh Rath <krath@quantenna.com>
Subject: Re: [v2, RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <20160719073947.2345561267@smtp.codeaurora.org>
	<c9a9f9f2-2943-14d2-3b5d-c401e870d7a0@quantenna.com>
Date: Tue, 26 Jul 2016 18:15:58 +0300
In-Reply-To: <c9a9f9f2-2943-14d2-3b5d-c401e870d7a0@quantenna.com> (Igor
	Mitsyanko's message of "Thu, 21 Jul 2016 10:26:39 -0700")
Message-ID: <87h9bcctw1.fsf@kamboji.qca.qualcomm.com> (sfid-20160726_171608_214781_2DBB7485)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> writes:

>     I applied this to the pending branch so that kbuild bot can run build tests on
>     it. Let's see what it finds.
>
>
>
> Kalle, I think you did that before already, at least I have received a
> following error report a while back:
>
>
> Hi,
>
> [auto build test ERROR on wireless-drivers-next/master]
> [also build test ERROR on v4.7-rc4 next-20160620]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/igor-mitsyanko-os-quantenna-com/qtnfmac-announcement-of-new-FullMAC-driver-for-Quantenna-chipsets/20160621-061419
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: m32r-allyesconfig (attached as .config)
> compiler: m32r-linux-gcc (GCC) 4.9.0
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=m32r

I suspect that in this case the kbuild bot took the patch from the
mailing list and run some quick tests on that. But AFAIK commits on a
git tree get wider testing.

-- 
Kalle Valo

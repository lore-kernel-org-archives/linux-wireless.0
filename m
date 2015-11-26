Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43091 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbbKZSej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 13:34:39 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mark Brown <broonie@kernel.org>
CC: <linaro-kernel@lists.linaro.org>,
	<kernel-build-reports@lists.linaro.org>, <netdev@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<linux-next@vger.kernel.org>
Subject: Re: next-20151126 build: 3 failures 15 warnings (next-20151126)
References: <E1a1sVV-00079q-My@optimist> <20151126121551.GE1929@sirena.org.uk>
	<87y4dllysz.fsf@kamboji.qca.qualcomm.com>
	<20151126132228.GG1929@sirena.org.uk>
	<87lh9kn1dz.fsf@kamboji.qca.qualcomm.com>
	<20151126170300.GH1929@sirena.org.uk>
Date: Thu, 26 Nov 2015 20:34:20 +0200
In-Reply-To: <20151126170300.GH1929@sirena.org.uk> (Mark Brown's message of
	"Thu, 26 Nov 2015 17:03:00 +0000")
Message-ID: <878u5kmwya.fsf@kamboji.qca.qualcomm.com> (sfid-20151126_193447_883174_949F8A62)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mark Brown <broonie@kernel.org> writes:

> On Thu, Nov 26, 2015 at 06:58:32PM +0200, Kalle Valo wrote:
>> Mark Brown <broonie@kernel.org> writes:
>
>> > No, I didn't make much effort to check though since the use of ifdef was
>> > clearly a bug waiting to happen anyway, I was more surprised it worked
>> > at all than anything.
>
>> Michal Marek explains[1] that this is due to commit cf4f21938e13
>> ("kbuild: Allow to specify composite modules with modname-m") and has
>> nothing to do with the wireless drivers reorganisation. I'll drop this
>> patch as Michal will apply his fix to the kbuild tree.
>
> It still ought to be fixed regardless of why it showed up - the
> intention of the code is that we build the real thermal code regardless
> of if that's modular or not but that's not what the code actually does.

Like I said above Michal will apply a fix to his tree. Read the full
discussion from patchwork:

https://patchwork.kernel.org/patch/7707801/

-- 
Kalle Valo

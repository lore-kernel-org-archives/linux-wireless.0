Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36097 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3LKVf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 16:35:27 -0500
Message-ID: <52A8DA9A.50501@gmail.com> (sfid-20131211_223542_852680_5E840CD1)
Date: Wed, 11 Dec 2013 23:35:22 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>,
	=?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@adurom.com>,
	Luciano Coelho <luca@coelho.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, freemangordon@abv.bg,
	aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
	joni.lapilainen@gmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting
 permanent mac address
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>	 <201312101814.35112@pali> <1386697762.30202.6.camel@dcbw.foobar.com>	 <201312101852.17030@pali> <1386796654.1516.268.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1386796654.1516.268.camel@bwh-desktop.uk.level5networks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 11.12.2013 23:17, Ben Hutchings wrote:
> I think that's an even worse idea.  This is not firmware and it already
> exists in separate storage.
>
> I think that rx51_init_wl1251() in
> arch/arm/mach-omap2/board-rx51-peripherals.c should either copy the MAC
> address out of NVRAM, or if it's too early to do that, then schedule a
> function to run later and only then set up wl1251 platform data.
>
> Ben.
>

And how will that work with DT when board files will be in the history?

Ivo

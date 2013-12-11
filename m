Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.solarflare.com ([12.187.104.25]:63323 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3LKV2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 16:28:51 -0500
Message-ID: <1386797325.1516.275.camel@bwh-desktop.uk.level5networks.com> (sfid-20131211_222858_457795_C033A8B0)
Subject: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting
 permanent mac address
From: Ben Hutchings <bhutchings@solarflare.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@adurom.com>,
	"Luciano Coelho" <luca@coelho.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <freemangordon@abv.bg>,
	<aaro.koskinen@iki.fi>, <pavel@ucw.cz>, <sre@ring0.de>,
	<joni.lapilainen@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felipe Contreras <felipe.contreras@gmail.com>
Date: Wed, 11 Dec 2013 21:28:45 +0000
In-Reply-To: <1386796654.1516.268.camel@bwh-desktop.uk.level5networks.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <201312101814.35112@pali> <1386697762.30202.6.camel@dcbw.foobar.com>
	 <201312101852.17030@pali>
	 <1386796654.1516.268.camel@bwh-desktop.uk.level5networks.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-11 at 21:17 +0000, Ben Hutchings wrote:
> On Tue, 2013-12-10 at 18:52 +0100, Pali Rohár wrote:
[...]
> > Maybe another way could be to use request_firmware to load address 
> > from userspace... Or what do you think?
> 
> I think that's an even worse idea.  This is not firmware and it already
> exists in separate storage.
[...]

Actually, as it seems you meant to do some kind of dynamic conversion, I
think it's not so bad.  Unfortunately I don't think it can work as I
explained in my other email.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


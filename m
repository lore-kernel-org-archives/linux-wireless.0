Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51935 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbcGZPMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2016 11:12:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jouni Malinen <j@w1.fi>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 5/9] mwifiex: cfg80211 set_default_mgmt_key handler
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
	<1468248832-21969-6-git-send-email-akarwar@marvell.com>
	<87r3aqx3sq.fsf@kamboji.qca.qualcomm.com>
	<33207c0c98c646548bdedf50449719c2@SC-EXCH04.marvell.com>
	<20160721155131.GA6292@w1.fi>
Date: Tue, 26 Jul 2016 18:12:17 +0300
In-Reply-To: <20160721155131.GA6292@w1.fi> (Jouni Malinen's message of "Thu,
	21 Jul 2016 18:51:31 +0300")
Message-ID: <87r3agcu26.fsf@kamboji.qca.qualcomm.com> (sfid-20160726_171227_002195_ADD5C876)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

> On Thu, Jul 21, 2016 at 09:18:11AM +0000, Amitkumar Karwar wrote:
>> > From: Kalle Valo [mailto:kvalo@codeaurora.org]
>> > Is it correct to ignore the key index? I see that brcmfmac ignores it as
>> > well but I want to still confirm this.
>> > 
>> > Does this mean that with this patcfh mwifiex properly supports MFP?
>> 
>> Yes. We do pass MFP tests with this patch.
>
> Did you test IGTK rekeying? This patch looks exactly as broken as it did
> the last time it was proposed more than a year ago and after the same
> concern not receiving any reaction..

Indeed, I had already forgetten that this patch was submitted February
2015:

https://patchwork.kernel.org/patch/5819421/

Please don't do like this and repost patches without earlier comments
addressed (or at least document the history).

-- 
Kalle Valo

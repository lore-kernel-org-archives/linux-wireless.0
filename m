Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50117 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbbIGNhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 09:37:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
	<87383kps0o.fsf@kamboji.qca.qualcomm.com>
	<wrfjvbggfhuj.fsf@redhat.com>
	<8737yrhdm0.fsf@kamboji.qca.qualcomm.com>
	<55EC6CBC.90504@lwfinger.net>
Date: Mon, 07 Sep 2015 16:37:45 +0300
In-Reply-To: <55EC6CBC.90504@lwfinger.net> (Larry Finger's message of "Sun, 6
	Sep 2015 11:41:32 -0500")
Message-ID: <87oahecpue.fsf@kamboji.qca.qualcomm.com> (sfid-20150907_153754_109065_2BF55587)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

>> It's easier that the driver has it's on directory as everything
>> (makefile, kconfig etc) is cleanly separated. And actually I would like
>> to create a new vendor directory for realtek and have this in
>> drivers/net/wireless/realtek/rtl8xxxu/. And later we could move rtlwifi
>> under realtek directory as well.
>
> I agree with the proposal for this driver to be under a separate
> directory. As this driver evolves to support more devices, it will
> likely be useful to split the current single .c file into a set of
> files, each containing the specific code needed for a given device. At
> that point, placing these files into a separate directory will be
> needed to keep the base drivers/net/wireless/ as clean as possible. We
> might as well do that now. I have no objections to moving rtlwifi
> under drivers/net/wireless/realtek/.

Great.

> We should even move rtl818x as well.

Good point, need to remember that.

-- 
Kalle Valo

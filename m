Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35435 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbbHYNAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 09:00:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Oscar Rydberg <oscarrydberg@gmail.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<twilightrook@gmail.com>, Michal Kazior <michal.kazior@tieto.com>,
	<joseph.salisbury@canonical.com>, <vvanpo@gmail.com>
Subject: Re: [PATCH/RFT 0/2] ath10k: add qca6164 support
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
	<CAAay3RQ7N4CFpY3ffxc83Xh2rPDFxne9DZKi+Pay4-Z-+XQ5Bg@mail.gmail.com>
	<2368480.ClS0E9V45b@wuerfel>
Date: Tue, 25 Aug 2015 16:00:20 +0300
In-Reply-To: <2368480.ClS0E9V45b@wuerfel> (Arnd Bergmann's message of "Thu, 20
	Aug 2015 15:22:11 +0200")
Message-ID: <87a8tf5xqz.fsf@kamboji.qca.qualcomm.com> (sfid-20150825_150039_530869_08C3F8ED)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Tuesday 18 August 2015 11:52:45 Oscar Rydberg wrote:
>> I can confirm this patch did it for my Lenovo Yoga 3 14 with QCA6164, the
>> WLAN interface is now alive, up and running perfectly fine!
>> (After running modprobe -r ideapad-laptop that is, should anyone have
>> trouble enabling it)
>> 
>> I had tried all the board.bin files from the windows drivers before, so the
>> added sanity check seems to be what finally solved it.

Odd, I didn't see this mail from Oscar and almost missed it. Maybe the
mailing list blocked it?

Anyway, thanks for testing. I'll try to get patch 1 to Linux 4.3 so that
it would have proper qca6164 support. If there are issues still, we can
fix those in a followup patch.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56018 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab3GTLki (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 07:40:38 -0400
Received: from zwerg.Speedport_W_723V_1_28_000 ([93.218.114.45]) by
 mail.gmx.com (mrgmx001) with ESMTPSA (Nemesis) id 0MUHoI-1UZSDJ2cWQ-00Qy9D
 for <linux-wireless@vger.kernel.org>; Sat, 20 Jul 2013 13:40:36 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: stable@vger.kernel.org, Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 0/2] ath9k_htc fixes, resend
Date: Sat, 20 Jul 2013 13:40:13 +0200
Message-Id: <51EA76A6.8090006@rempel-privat.de> (sfid-20130720_134104_669203_E2552369)
MIME-Version: 1.0
References: <1374257778-9758-1-git-send-email-linux@rempel-privat.de> <201307200143.56632.s.L-H@gmx.de>
In-Reply-To: <201307200143.56632.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oleksij Rempel <linux@rempel-privat.de>

Am 20.07.2013 01:43, schrieb Stefan Lippers-Hollmann:
> Hi
>
> On Friday 19 July 2013, Oleksij Rempel wrote:
>> Hi John,
>> this patches needed to fix firmare/adapter hang issue on
>> reboot or module reload.
>>
>> Oleksij Rempel (2):
>>    ath9k_htc: do some initial hardware configuration
>>    ath9k_htc: reboot firmware if it was loaded
>
> Given that this is a longstanding issue, affecting actual users, I'd
> suggest to "Cc: <stable@vger.kernel.org>" for these patches. They
> should meet the bar even under the new, stricter, interpretation of
> the -stable rules and are small and self contained.

ok, thank you for the tip.

-- 
Regards,
Oleksij

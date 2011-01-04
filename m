Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38582 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1ADWbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 17:31:06 -0500
Received: by wyb28 with SMTP id 28so14795861wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 14:31:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikCcgEiqeJLDn0Pes_2=usj6ZXo7hhL48MBnH_-@mail.gmail.com>
References: <AANLkTim0AM3=T=TMu79ZQi79+CKANamBcz620n2xm8bW@mail.gmail.com>
	<201101041946.56978.helmut.schaa@googlemail.com>
	<AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
	<AANLkTi=KFG-7GPw2=6VTZqEceEcJM6OdWoTQaN_83NqP@mail.gmail.com>
	<AANLkTikREOFV+WGWgo9yh9bTrz346kF0muKE8gs5N+km@mail.gmail.com>
	<AANLkTikCcgEiqeJLDn0Pes_2=usj6ZXo7hhL48MBnH_-@mail.gmail.com>
Date: Tue, 4 Jan 2011 23:31:03 +0100
Message-ID: <AANLkTin0W1_Tjr1zj0D0U+VeBpoGFRmB9iCdOfnMB-nR@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
From: Wolfgang Kufner <wolfgang.kufner@gmail.com>
To: Aleksandar Milivojevic <alex@milivojevic.org>
Cc: Luis Correia <buga@loide.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Aleksandar,	

I know just about nothing about regulatory domains but I think it
might be good to try with a current compat-wireless next. I notice
that the these log lines:

"cfg80211: Received country IE:"
"cfg80211: We intersect both of these and get:"

do not exist in linux-next anymore since this commit:
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=4f366c5dabcb936dd5754a35188bd699181fe1ce

Maybe a fix for this issue is already in compat-wireless.

HTH,
Wolfgang

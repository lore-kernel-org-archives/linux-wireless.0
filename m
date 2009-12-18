Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36382 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZLRLmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 06:42:55 -0500
Received: by ewy19 with SMTP id 19so1382538ewy.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 03:42:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890912080830v40ff214co178fb17c38439e70@mail.gmail.com>
References: <bf87febf0912030507u1c36f6a9h7cac0efabf3d016@mail.gmail.com>
	 <20091204192315.GA5786@tuxdriver.com>
	 <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com>
	 <20091207215903.GC18939@tuxdriver.com>
	 <b6c5339f0912080657s7cfccd4dp6525702e609bdd5f@mail.gmail.com>
	 <43e72e890912080801s52607743s738ed6cdad7d154e@mail.gmail.com>
	 <20091208160659.GG15172@tuxdriver.com>
	 <43e72e890912080830v40ff214co178fb17c38439e70@mail.gmail.com>
Date: Fri, 18 Dec 2009 13:42:52 +0200
Message-ID: <bf87febf0912180342w134d92eblc24f326cfa751b08@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add support for Dell Vostro A860 LED
From: Shahar Or <mightyiampresence@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2009 at 6:30 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
>>> IIRC this is all mapped in the INF file, I thought I had released an
>>> INF file under the ISC license but it seems that's not the case, I can
>>> try to do that if it helps. Anyway, if we can move this sort of map to
>>> userspace it'd be neat as you'd just need a userspace file update.
>>> Only thing is how to do this in a generic way for all wireless drivers
>>> and if this is indeed useful for other drivers.
>>
>> Export something through sysfs and use a udev rule?
>
> True. Is sysfs the preferred fs nowadays, what about configfs? Or
> maybe even udev rule --> nl80211 ?

If we have all the IDs from the INF file, then why do we need this in
userspace? Is the list growing?

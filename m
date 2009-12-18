Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:45885 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZLRRD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 12:03:28 -0500
Received: by fxm21 with SMTP id 21so3011196fxm.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 09:03:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890912180737s382c24c5q8720f1e3138fefb@mail.gmail.com>
References: <bf87febf0912030507u1c36f6a9h7cac0efabf3d016@mail.gmail.com>
	 <20091204192315.GA5786@tuxdriver.com>
	 <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com>
	 <20091207215903.GC18939@tuxdriver.com>
	 <b6c5339f0912080657s7cfccd4dp6525702e609bdd5f@mail.gmail.com>
	 <43e72e890912080801s52607743s738ed6cdad7d154e@mail.gmail.com>
	 <20091208160659.GG15172@tuxdriver.com>
	 <43e72e890912080830v40ff214co178fb17c38439e70@mail.gmail.com>
	 <bf87febf0912180342w134d92eblc24f326cfa751b08@mail.gmail.com>
	 <43e72e890912180737s382c24c5q8720f1e3138fefb@mail.gmail.com>
Date: Fri, 18 Dec 2009 19:03:26 +0200
Message-ID: <bf87febf0912180903x168462ffw6c9faeac0cd1596c@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add support for Dell Vostro A860 LED
From: Shahar Or <mightyiampresence@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 18, 2009 at 5:37 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
>> If we have all the IDs from the INF file, then why do we need this in
>> userspace? Is the list growing?
>
> No, but for other newer hardware/drivers it can likely grow, so my
> comment was more of a generic driver approach to this.

Is this a linux-wireless thing, or do other areas of linux keep some
data in userspace?

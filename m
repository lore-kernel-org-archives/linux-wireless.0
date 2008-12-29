Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:29577 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYL2QoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 11:44:06 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1527658ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 08:44:04 -0800 (PST)
Message-ID: <43e72e890812290844y56c6c4c9v24c99ccc0c010261@mail.gmail.com> (sfid-20081229_174411_205318_F9914DEF)
Date: Mon, 29 Dec 2008 08:44:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: [ath9k-devel] [PATCH v3 02/16] ath9k: use hw->conf on ath_setcurmode()
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <18776.62379.965798.668056@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com>
	 <1230076731-22946-2-git-send-email-lrodriguez@atheros.com>
	 <1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
	 <18776.21485.750323.652519@gargle.gargle.HOWL>
	 <20081229154453.GP5944@tesla>
	 <18776.62379.965798.668056@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 29, 2008 at 7:58 AM, Sujith <m.sujith@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>> > We don't have separate rate tables for ht20, ht40+, ht40-.
>> > Setting cur_rate_table just once using conf_is_ht() to any HT mode would suffice.
>>
>> I do see we have different rate tables for these though, do you mean we can
>> consolidate on the rate tables?
>
> We have only 2 HT rate tables, ar5416_11na_ratetable and ar5416_11ng_ratetable.
> The different HT modes point to the same tables, in ath_rate_attach().

Oh very nice, I failed to notice that, thanks!

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:50991 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbZAWUSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 15:18:36 -0500
Received: by ewy13 with SMTP id 13so3977977ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 12:18:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4979F177.1060004@lwfinger.net>
References: <4979269F.1060500@lwfinger.net>
	 <20090123021413.GB3177@tuxdriver.com> <4979567D.2020005@lwfinger.net>
	 <20090123071345.270730@gmx.net> <4979F177.1060004@lwfinger.net>
Date: Fri, 23 Jan 2009 21:18:34 +0100
Message-ID: <2d0a357f0901231218j3ae2989cpcd2bf254931f04c0@mail.gmail.com> (sfid-20090123_211840_865918_C4DBEDC3)
Subject: Re: Regression caused by commit e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, maximlevitsky@gmail.com,
	kalle.valo@iki.fi, samuel@sortiz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the confusion, it's
"mac80211-Fixed-BSSID-handling-revisited-v3.patch" (not v4, see [1]).
And as I mentioned before - it works for me, too.
I requested to Alina to send a separate email incl. this new v3 patch.
Hope this will stop confusing.

Don't know if Samuels complains about if_config()/STA mode for iwl4965
[2] were clarified in the meantime.

-SD

[1] http://marc.info/?l=linux-wireless&m=123270461025225&w=2
[2] http://marc.info/?l=linux-wireless&m=123271402006665&w=2

On Fri, Jan 23, 2009 at 5:33 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> I saw some mention of a V4 of this patch in other mails but V3 fixes
> the problem for me.
>
> Larry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

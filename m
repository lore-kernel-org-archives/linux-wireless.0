Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:26004 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZDNU3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 16:29:51 -0400
Received: by fg-out-1718.google.com with SMTP id 16so532715fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2009 13:29:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904142159.59511.chunkeey@web.de>
References: <200904142159.59511.chunkeey@web.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 14 Apr 2009 22:29:34 +0200
Message-ID: <69e28c910904141329o731a7bcfjde0e5587c20e9058@mail.gmail.com> (sfid-20090414_234556_089193_4B3FCF4E)
Subject: Re: [RFC] ar9170: 802.11n RX Part
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 14, 2009 at 9:59 PM, Christian Lamparter <chunkeey@web.de> =
wrote:
> With this patch you can finally tune your ar9170 radio to the next ne=
twork
> and listen to the sound of HT.
>
> Of course, you won't be able to sing along with all other 11n devices=
=2E
> We still need a rate algo, BA support (weird stuff!) for HT before
> we can think about coding it.
>
> Regards,
> =A0 =A0 =A0 =A0Chr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

A rate algo is needed because wext doesn't support HT rates, and
nl80211 doesn't yet have a rate selection feature, preventing manual
setting of HT rates, right?

--G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

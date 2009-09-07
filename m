Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:35769 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZIGSJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 14:09:15 -0400
Received: by fg-out-1718.google.com with SMTP id 22so808558fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 11:09:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909071711.18632.hs4233@mail.mn-solutions.de>
References: <200909071711.18632.hs4233@mail.mn-solutions.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 7 Sep 2009 20:08:56 +0200
Message-ID: <69e28c910909071108t1956b0dfj7f96cac84d9088d6@mail.gmail.com>
Subject: Re: iw: strange output
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 7, 2009 at 5:11 PM, Holger
Schurig<hs4233@mail.mn-solutions.de> wrote:
> I'm using
>
> * wpasupplicant: hostap_0_6_7-490-g52eb293
> * iw: v0.9.17-1-gdbaabba
> * linux-wl: v2.6.31-rc8-34797-g4910edb
> * some ath5k.ko supported card
>
>
> For wpa_supplicant, I'm currently using the wext driver.
>
> When I associate while "iw event" is running, I see the following
> strange output:
>
> eth1 (phy #0): scan finished: 2412, "g\xc6isQ\xffJ\xec)\xcd\xba\xab\xf2\xfb\xe3F|\xc2T\xf8\x1b\xe8\xe7\x8dvZ.c3\x9f\xc9\x9a"
>
> Is that garbage at the end intentional?
>
>
>
>
> P.S.: when I'm using nl80211 driver for wpa_supplicant, I seem
> to be associated, but no ping goes throught.

I can also confirm that. It appears to be a regression from the "big
state machine monster is no more" change.

>
> --
> http://www.holgerschurig.de
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

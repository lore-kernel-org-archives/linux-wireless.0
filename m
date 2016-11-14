Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm15-vm5.bullet.mail.ir2.yahoo.com ([212.82.96.202]:59688 "EHLO
        nm15-vm5.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932354AbcKNLjh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 06:39:37 -0500
Date: Mon, 14 Nov 2016 11:34:13 +0000 (UTC)
From: Gianfranco Costamagna <locutusofborg@debian.org>
Reply-To: Gianfranco Costamagna <locutusofborg@debian.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "nsmaldone@tierratelematics.com" <nsmaldone@tierratelematics.com>,
        "Marco.Arlone@roj.com" <Marco.Arlone@roj.com>
Message-ID: <233918815.6357602.1479123253455@mail.yahoo.com> (sfid-20161114_123940_802702_73FA0D90)
In-Reply-To: <0812c8f2-f0ce-c62c-5f09-fa46dafd630f@broadcom.com>
References: <CACJOhtL-oFTJC5j0_+fdecWExZBKvDy13o+UBzw47tyrvD_SJQ@mail.gmail.com> <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com> <690669269.1124561.1477671348137@mail.yahoo.com> <5474e850-1c52-c896-da9e-45720ed6d6ff@broadcom.com> <0812c8f2-f0ce-c62c-5f09-fa46dafd630f@broadcom.com>
Subject: Re: [PATCH] broadcom/brcm80211/brcmfmac/cfg80211 driver, bad
 regulatory domain frequency value
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,


>Finally response. As it turns out the range was explcitly changed

>enabling channels 12 and 13 to be used where applicable. They forgot to
>update the comment.


so, the struct in net/wireless/reg.c is actually used in that case?

static const struct ieee80211_regdomain world_regdom = {

do you plan to update the comment?

thanks!

Gianfranco

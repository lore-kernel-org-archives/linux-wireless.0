Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59202 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbeHMPWa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 11:22:30 -0400
Received: from mail-it0-f71.google.com ([209.85.214.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fpC90-0003s8-Qh
        for linux-wireless@vger.kernel.org; Mon, 13 Aug 2018 12:40:22 +0000
Received: by mail-it0-f71.google.com with SMTP id m185-v6so9149772itm.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 05:40:22 -0700 (PDT)
Date: Mon, 13 Aug 2018 07:40:19 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: bkil <bkil.hu+Aq@gmail.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless-regdb: update rules for Hungary (HU) on
 2.4/5/60G, 5725-5875MHz
Message-ID: <20180813124019.GA4063@ubuntu-xps13> (sfid-20180813_144054_033238_96557FA9)
References: <CAPuHQ=EWtsOs2naY2pLx9D-JJbDr1kc8sisd-JNHiEekJ5ijDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPuHQ=EWtsOs2naY2pLx9D-JJbDr1kc8sisd-JNHiEekJ5ijDQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 30, 2018 at 10:40:34PM +0200, bkil wrote:
> * 2400-2483.5M: extend bounds
> * 5150-5250M: extend bounds, add NO-OUTDOOR, no TPC so +3dB
> * 5250-5350M: extend bounds, add NO-OUTDOOR
> * 5470-5725M: extend bounds
> * 5725-5875M: introduce, as EU SRD provisions have been implemented
> * 57-66G: add NO-OUTDOOR
> 
> Freely available online references have been added hosted by the regulatory
> body in Hungary, the National Media and Infocommunications Authority.
> 
> To refer to a specific section, you can grep for the frequency in question.
> 
> Translation key:
> "Csak beltéri" / "Épületen belüli használatra korlátozott" = indoor only;
> "Kültéri és beltéri" = both indoor and outdoor;
> "Nem működő TPC esetén a maximális teljesítményjellemzők 3 dB-lel
> csökkennek." = reduce max power specs by 3dB in case of no TPC;
> "Rögzített kültéri telepítés nem megengedett" = no fixed outdoor install
> 
> Signed-off-by: bkil <b.K.il.h.u+tigbuh@gmail.com>

Applied, thanks!

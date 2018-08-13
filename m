Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59231 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbeHMPYv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 11:24:51 -0400
Received: from mail-it0-f72.google.com ([209.85.214.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fpCBG-0003xc-Sr
        for linux-wireless@vger.kernel.org; Mon, 13 Aug 2018 12:42:42 +0000
Received: by mail-it0-f72.google.com with SMTP id h17-v6so9170452itj.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 05:42:42 -0700 (PDT)
Date: Mon, 13 Aug 2018 07:42:39 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: bkil <bkil.hu+Aq@gmail.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless-regdb: update rules for Hungary (HU) on
 2.4/5/60G, 5725-5875MHz
Message-ID: <20180813124239.GB4063@ubuntu-xps13> (sfid-20180813_144253_264526_B7C5F35E)
References: <CAPuHQ=EWtsOs2naY2pLx9D-JJbDr1kc8sisd-JNHiEekJ5ijDQ@mail.gmail.com>
 <20180813124019.GA4063@ubuntu-xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180813124019.GA4063@ubuntu-xps13>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2018 at 07:40:19AM -0500, Seth Forshee wrote:
> On Sat, Jun 30, 2018 at 10:40:34PM +0200, bkil wrote:
> > * 2400-2483.5M: extend bounds
> > * 5150-5250M: extend bounds, add NO-OUTDOOR, no TPC so +3dB
> > * 5250-5350M: extend bounds, add NO-OUTDOOR
> > * 5470-5725M: extend bounds
> > * 5725-5875M: introduce, as EU SRD provisions have been implemented
> > * 57-66G: add NO-OUTDOOR
> > 
> > Freely available online references have been added hosted by the regulatory
> > body in Hungary, the National Media and Infocommunications Authority.
> > 
> > To refer to a specific section, you can grep for the frequency in question.
> > 
> > Translation key:
> > "Csak beltéri" / "Épületen belüli használatra korlátozott" = indoor only;
> > "Kültéri és beltéri" = both indoor and outdoor;
> > "Nem működő TPC esetén a maximális teljesítményjellemzők 3 dB-lel
> > csökkennek." = reduce max power specs by 3dB in case of no TPC;
> > "Rögzített kültéri telepítés nem megengedett" = no fixed outdoor install
> > 
> > Signed-off-by: bkil <b.K.il.h.u+tigbuh@gmail.com>
> 
> Applied, thanks!

Replied to the wrong message in the thread, to be clear what I applied
was the v3 patch.

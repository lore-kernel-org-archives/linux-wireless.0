Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbeINU57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Sep 2018 16:57:59 -0400
Message-ID: <cc038bb1e343b04f837af72f9ce9b815bf4c73ea.camel@redhat.com> (sfid-20180914_174258_756231_D25C3F32)
Subject: Re: mt76x0 bug report
From: Davide Caratti <dcaratti@redhat.com>
To: Sid Hayn <sidhayn@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: sgruszka@redhat.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
In-Reply-To: <CAM0KTbAu-LJ2ThAHbmbrggMw_ttpQ8fXr0+HTjGBZF6PBPiD8Q@mail.gmail.com>
References: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
         <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com>
         <CAM0KTbAbjDYNOzivxMdLmYrV9QHgwkLp7zXpdCvn1Kf1uEcQTQ@mail.gmail.com>
         <20180906093213.GB16539@redhat.com>
         <CAM0KTbBRGqNAu1H0myVoWg6Qu1aMXMneSJ7bXQUKbJGZUFkC_A@mail.gmail.com>
         <CAJ0CqmXHHE2J5O4irPogrypL_H95EDm2y+1_6rpWG1v3ZHxzXA@mail.gmail.com>
         <CAM0KTbAF_ztZzFk_iECyPbiWY69xrcdT_93ypnuTzocjX_fRuQ@mail.gmail.com>
         <20180907082413.GC2725@localhost.localdomain>
         <CAM0KTbAputKNN3seOfN-1zhz5XmT6yg_pbKBnapOsR6Vigv1XQ@mail.gmail.com>
         <CAM0KTbAu-LJ2ThAHbmbrggMw_ttpQ8fXr0+HTjGBZF6PBPiD8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2018 17:42:50 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-09-14 at 11:32 -0400, Sid Hayn wrote:
> Secondarily, ethtool still doesn't report firmware version and that
> would be a very helpful thing to have before 4.19 hits.

hello,

I just tested a draft patch for mt76 addressing the missing FW version in
ethtool, will send it to the ML in the next days.

regards,
-- 
davide

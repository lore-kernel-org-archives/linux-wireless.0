Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932176AbcKNJpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 04:45:34 -0500
Date: Mon, 14 Nov 2016 10:44:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Mathias Kresin <dev@kresin.me>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 05/10] rt2800: make ba_size depend on ampdu_factor
Message-ID: <20161114094413.GA13494@redhat.com> (sfid-20161114_104539_209467_6936AC85)
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-6-git-send-email-sgruszka@redhat.com>
 <ebc4779b-a68b-f3b3-c8fc-87db9401a603@kresin.me>
 <20161114084536.GB12372@redhat.com>
 <CAGRGNgU=3tRrdgzoiGjoGr6QguyYnQ2kadiaX+HWxm0jiKqaqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgU=3tRrdgzoiGjoGr6QguyYnQ2kadiaX+HWxm0jiKqaqw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Nov 14, 2016 at 08:41:57PM +1100, Julian Calaby wrote:
> > -               rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 1);
> > +               rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 3;
> 
> You're missing a closing parenthesis, so it isn't going to work unless
> it's added back in.

Thanks for the notice, hopefully Mathias can fix that.

Stanislaw

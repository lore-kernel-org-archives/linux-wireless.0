Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAF9C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 14:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F09322089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 14:32:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F09322089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbeJCVVL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 17:21:11 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:41183 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbeJCVVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 17:21:11 -0400
Received: by mail-io1-f42.google.com with SMTP id q4-v6so5183785iob.8
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 07:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P93jLOM8A7Exf8E96LNWD8xw1+Jhx/VZDtCGcZFYTOo=;
        b=KBj5S6MU3xNoZroTAHr3hXVaevKiFjbTLQZvcwQPyhKQIxC7v5w06gbmNxDZJTSUGK
         Ak/h6PiCVSA2UpAT+2uQPSoUWsL89ZgCJsntx78UQn+hMGBaLV81jPkugk0fZp1/YsN+
         0sKYf7WhPK6f1TNyvyrDHVKeaB/f+JhXd0H0CTScm2vzo4M4StOYX4wENTzskSDnTD8L
         JwxIsRsPxlP7/hDOF5s+iBEPwiTpO+eXgecYSYBeqT6cwVVdydXLQiODf6Xou0cacqf7
         kxU97PrfRAKbd4p9o6i+z46tnxtcOvrazmsTnponnsP8RrkJCAm/wy8F/eNQHQUiENSa
         IDGw==
X-Gm-Message-State: ABuFfohb71l5gARN2XBVb2KiEsgIEFQSNxMMiqEuHpr7N2uj30EPtv6u
        i2l3YrjFGU9wz0S4UVxcSMaHHvFYzbdBIxRHDKxyLA==
X-Google-Smtp-Source: ACcGV627ABLrO83wPRJaqWulJdnWRHp0g3wW08cvABz5c+wzj0HR+uxvoVifVV1p9mJLTIGV1YSC4+tuQFPV5nRgH5g=
X-Received: by 2002:a6b:c917:: with SMTP id z23-v6mr1195580iof.297.1538577151991;
 Wed, 03 Oct 2018 07:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20181003082309.GB2229@redhat.com> <20181003091536.GB27279@localhost.localdomain>
 <20181003102927.GA2250@redhat.com> <20181003140905.GF27279@localhost.localdomain>
 <20181003142307.GD2250@redhat.com>
In-Reply-To: <20181003142307.GD2250@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Wed, 3 Oct 2018 16:32:20 +0200
Message-ID: <CAJ0CqmW2CkkxEJedg6YD-Z5dZSwGBpV0PtHmTbDR7rQobPw8gA@mail.gmail.com>
Subject: Re: new mt76 usb crashes on device removal
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Wed, Oct 03, 2018 at 04:09:06PM +0200, Lorenzo Bianconi wrote:
> > > It still crashes. You can not reproduce the problem ?
> > > It's 100% reproducible for me, when I unplug mt76x0u or mt76x2 device.
> >
> > Hi Stanislaw,
> >
> > any news about the latest patchset I sent to fix that issue?
>
> It fixed the problem, I thought you tested that by yourself.

Yes, I did. I would like to have even a confirmation from you. Thanks.

Regards,
Lorenzo

>
> Regards
> Stanislaw

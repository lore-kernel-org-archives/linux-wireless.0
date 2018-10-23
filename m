Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BA8C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 18:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B6192075D
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 18:08:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B6192075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbeJXCcv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 22:32:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:54168 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725997AbeJXCcv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 22:32:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EBF30B034;
        Tue, 23 Oct 2018 18:08:22 +0000 (UTC)
Date:   Tue, 23 Oct 2018 20:08:21 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc:     Theodore Ts'o <tytso@mit.edu>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Is Fixes line enough?
In-Reply-To: <CAKdAkRQvwe93nwLgEQuSsmbUbzMzVjO22wrfg=wzQtfHoSq2DA@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.1810232007500.23511@cbobk.fhfr.pm>
References: <a99840d5-7d57-ec1f-1c70-37ffa6cfd31b@lwfinger.net> <20181023143856.GD6850@thunk.org> <alpine.LRH.2.00.1810231833260.2860@gjva.wvxbf.pm> <20181023173747.GG6850@thunk.org> <CAKdAkRQvwe93nwLgEQuSsmbUbzMzVjO22wrfg=wzQtfHoSq2DA@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 23 Oct 2018, Dmitry Torokhov wrote:

> > Ah, I didn't get that you were trying to suggest that things only go 
> > into stable if it has both Fixes: *and* Cc: Stable.
> >
> > If that's the problem you were trying to solve, perhaps we could ask
> > Stephen Rothwell if he would be willing to run a script that sends
> > nag-o-grams to Maintainers who incluce patches in linux-next that have
> > Cc: stable but neither Fixes nor a "# 4.x" appended to the end of the
> > Cc: stable line?
> >
> 
> Patches adding new PCI/USB/ACPI IDs or DMI quirks are usually accepted
> into stable but normally lack "Fixes" tag.

That could easily be made an easily identifiable exception to the rule 
though.

-- 
Jiri Kosina
SUSE Labs


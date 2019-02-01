Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A72C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 22:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EEE320869
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 22:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfBAWSM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 17:18:12 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:50512 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfBAWSM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 17:18:12 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gph8U-0008B8-K3; Fri, 01 Feb 2019 23:18:10 +0100
Message-ID: <d4715a263661f442e1d610c63981a256fcba82e6.camel@sipsolutions.net>
Subject: Re: iw release cadence?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 01 Feb 2019 23:18:09 +0100
In-Reply-To: <CA+ASDXMNu2Jv1nFCWMtg6bcks-XKv1fTGr6j2f0TdgtAhkQK3w@mail.gmail.com> (sfid-20190201_231724_438987_1329FC1E)
References: <CA+ASDXMVAP4CsE=vaomOn5mu_uAM0jc3jvWGzaVPFFif4kTX+Q@mail.gmail.com>
         <2d274e00c3e15e9786ccc865215d9853a5ab30f0.camel@sipsolutions.net>
         <3282a26ab610c1590742c0d50632c35ae4bb82c8.camel@sipsolutions.net>
         <CA+ASDXMNu2Jv1nFCWMtg6bcks-XKv1fTGr6j2f0TdgtAhkQK3w@mail.gmail.com>
         (sfid-20190201_231724_438987_1329FC1E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-02-01 at 14:17 -0800, Brian Norris wrote:
> On Fri, Feb 1, 2019 at 2:09 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2019-02-01 at 22:54 +0100, Johannes Berg wrote:
> > > 
> > > I'll just tag one now :-)
> > 
> > Done. I updated a few things and pulled in our FTM support code too, now
> > that all the nl80211.h api is upstream.
> 
> Awesome, thanks! Presumably a tarball is on its way?

Need to figure out how to use kup again ...

johannes


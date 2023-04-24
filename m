Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B387C77B61
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Apr 2023 06:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDXGTN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Apr 2023 02:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjDXGTB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2023 02:19:01 -0400
X-Greylist: delayed 1712 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 23 Apr 2023 23:19:00 PDT
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC822100
        for <linux-wireless@vger.kernel.org>; Sun, 23 Apr 2023 23:19:00 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.94.2)
        (envelope-from <mh+debian-packages@zugschlus.de>)
        id 1pqp5G-00Cdbd-An; Mon, 24 Apr 2023 07:49:54 +0200
Date:   Mon, 24 Apr 2023 07:49:54 +0200
From:   Marc Haber <mh+debian-packages@zugschlus.de>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        =?utf-8?Q?J=C3=BCrgen?= Bausa <Juergen.bausa@online.de>,
        Rene Engelhard <rene@debian.org>,
        Tycho Kirchner <tychokirchner@gmail.com>,
        Sebastian Suchanek <sebastian.suchanek@gmx.de>,
        Paul Muster <exp-311223@news.muster.net>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlwifi in German ICE4 trains
Message-ID: <ZEYYgjw3d9gwScra@torres.zugschlus.de>
References: <20230423085510.xpmcuzfhzqa4dyhs@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230423085510.xpmcuzfhzqa4dyhs@pengutronix.de>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Apr 23, 2023 at 10:55:10AM +0200, Uwe Kleine-König wrote:
> Tomorrow I might have the opportunity to test and reproduce the problem
> (I don't know if my train will be an ice4 or one of the older ones
> though.)

I can look up in advance what kind of train is planned for a certain
journey, I need train number and date for that. About one day in advance
I can say which EMU is planned for the trip.

I am also on Deutsche Bahn's customer advisory board ("Kundenbeirat"),
but I must say that Deutsche Bahn is not very enthusiastic in helping
with this issue. I do, however, have a quite direct link to the project
managers involved with Wifi On ICE. They seem to be keeping a close
guard over their tech staff though.

Thanks to all participants on this thread and issue on the Linux side,
we would not have come this far without your help.

Also, our current "fix" for the issue seems to have the side effect of
limiting the home network connection to 54 Mbit/s.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

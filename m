Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56360 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751797AbcITGkK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 02:40:10 -0400
Message-ID: <1474353599.5664.125.camel@coelho.fi> (sfid-20160920_084013_550569_899E669F)
From: Luca Coelho <luca@coelho.fi>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Lior David <liord@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: Maya Erez <merez@codeaurora.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 20 Sep 2016 09:39:59 +0300
In-Reply-To: <45d2980c-aeb4-4faa-e73f-75747124e9eb@broadcom.com>
References: <e7096bbb-ba66-e639-b86e-a483dc198b85@codeaurora.org>
         <45d2980c-aeb4-4faa-e73f-75747124e9eb@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: nl80211 fine timing measurement support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-09-19 at 20:42 +0200, Arend Van Spriel wrote:
> 
> On 19-9-2016 19:31, Lior David wrote:
> > 
> > Hi Johannes,
> > 
> > We are working on adding indoor location support to the wil6210
> > 11ad driver. This includes fine timing measurement (FTM) as well as
> > something we call angle of arrival (AOA) which measures azimuth and
> > elevation.
> > Initially we implemented it internally using vendor commands but we
> > would like to upstream it using standard nl80211 API.
> > I noticed a patch you sent some time ago (https://patchwork.kernel.
> > org/patch/7790701/) for adding fine timing measurement support to
> > nl80211, it looks like a good baseline though we do have few issues
> > with it... However I did not see any comments or response on this
> > patch. Can you please update if you plan on eventually submitting
> > this patch?
> 
> You can find several FTM related patches in backport-iwlwifi repo on
> kernel.org. See link to git log of nl80211.h there [1].

We have a full FTM implementation in our internal tree (which is
published in the URL Arend provided) and we are currently working on
cleaning it up for upstream submission.  You should see patches from us
this week.

--
Cheers,
Luca.

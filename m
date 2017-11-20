Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41122 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdKTQJH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 11:09:07 -0500
Message-ID: <1511194141.2030.46.camel@sipsolutions.net> (sfid-20171120_170915_958809_0B630156)
Subject: Re: [PATCH] mac80211: Update last_ack status for all except probing
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Date: Mon, 20 Nov 2017 17:09:01 +0100
In-Reply-To: <839c3938efae497e9058391fd4be4817@NALASEXR01H.na.qualcomm.com>
References: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
         <1509964164.2669.0.camel@sipsolutions.net>
         <8bb232d231884f9595c81f945a5eef4f@NALASEXR01H.na.qualcomm.com>
         <49241af7-a50f-5758-0c7e-77f2fae5d93d@quantenna.com>
         <96799d352b7347a8a9092bb37f1cd8d9@NALASEXR01H.na.qualcomm.com>
         <1510565141.30497.6.camel@sipsolutions.net>
         <839c3938efae497e9058391fd4be4817@NALASEXR01H.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-11-15 at 19:21 +0000, Rajkumar Manoharan wrote:
> > 
> Hmm.. But polling TX/RX counters will not give exact activity time. 

Yeah but if you do it every minute, you'll know if it was idle for
roughly 5 minutes, or so... dunno, things could be done.

> Moreover
> It will be useful if STA's last data activity tstamp is logged in station dump. No?

I don't object to adding that, though we should be careful with adding
things and see if we _really_ need them, since they all have a cost.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:57198 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbeHUMR4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 08:17:56 -0400
Message-ID: <1534841913.25523.0.camel@sipsolutions.net> (sfid-20180821_105841_103251_60977CFC)
Subject: Re: [RFC] cfg80211: let's wmm_rule be part of reg_rule structure
From: Johannes Berg <johannes@sipsolutions.net>
To: Grzegorz =?UTF-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Aug 2018 10:58:33 +0200
In-Reply-To: <7580e821-bfa0-e4d4-435f-a042b0eba555@gmail.com> (sfid-20180821_105723_922713_195D6893)
References: <20180821074020.GA28952@redhat.com>
         <7580e821-bfa0-e4d4-435f-a042b0eba555@gmail.com>
         (sfid-20180821_105723_922713_195D6893)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-21 at 10:57 +0200, Grzegorz Duszyński wrote:
> I've just briefly tested it, looks like it's working!
> I have only remote access to my machine at the moment so it's difficult 
> to say for sure if everything is in order.
> However stalls do not occur, nor there are any error/warnings anywhere.
> 
That probably just means you now have some invalid data somewhere,
rather than a crash... Not sure which is better - I guess you'd rather
have it not crash, and I'd rather figure out where the invalid data is
coming from :)

johannes

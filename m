Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44468 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbeCWISB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 04:18:01 -0400
Message-ID: <1521793079.4175.12.camel@sipsolutions.net> (sfid-20180323_091806_435960_CAE321D0)
Subject: Re: iwlwifi intermittent beacon capture in monitor mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tyler Gray <graytfg@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2018 09:17:59 +0100
In-Reply-To: <CAEo4QHxp3w=PKJ0jgvLNHarw92Ynt=eZNmoWE8w7ZMf_HP9MGw@mail.gmail.com> (sfid-20180322_215451_336645_EB5D4B75)
References: <CAEo4QHxp3w=PKJ0jgvLNHarw92Ynt=eZNmoWE8w7ZMf_HP9MGw@mail.gmail.com>
         (sfid-20180322_215451_336645_EB5D4B75)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>From a completely different angle than what James just said, are you
sure you're using the 7265 NIC for *only* monitor mode? This behaviour
would also be more or less consistent with the 7265 NIC being connected
to the AP that you're monitoring the beacons, since it would then
suppress beacon RX for powersaving purposes.

johannes

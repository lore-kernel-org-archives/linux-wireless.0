Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59264 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbeICN7y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:59:54 -0400
Message-ID: <1535967626.3437.32.camel@sipsolutions.net> (sfid-20180903_114137_120435_81FD89EF)
Subject: Re: Build iw for 32bit ARM
From: Johannes Berg <johannes@sipsolutions.net>
To: Steve deRosier <derosier@gmail.com>, jakov.simunic@ericsson.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 03 Sep 2018 11:40:26 +0200
In-Reply-To: <CALLGbRL+XDPk68LwBDoyVdibpNy314M81umexpUkHYn5TwA4RA@mail.gmail.com> (sfid-20180831_173150_396681_DC2791A8)
References: <HE1PR0702MB38043B23810E618B01413959980F0@HE1PR0702MB3804.eurprd07.prod.outlook.com>
         <CALLGbRL+XDPk68LwBDoyVdibpNy314M81umexpUkHYn5TwA4RA@mail.gmail.com>
         (sfid-20180831_173150_396681_DC2791A8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In addition or as an alternative to what Steve said, make sure your
LDFLAGS also contains -m32.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34332 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760132AbdLSJin (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 04:38:43 -0500
Message-ID: <1513676321.26145.1.camel@sipsolutions.net> (sfid-20171219_103848_547223_A849E6CB)
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 19 Dec 2017 10:38:41 +0100
In-Reply-To: <20171218161811.3f3sjhlxdfmsnljx@bars>
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
         <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
         <871skalepz.fsf@purkki.adurom.net> <20171205160010.cytra3bqbttwz5db@bars>
         <878te0kud2.fsf@kamboji.qca.qualcomm.com>
         <20171218161811.3f3sjhlxdfmsnljx@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-12-18 at 19:18 +0300, Sergey Matyukevich wrote:

> Meanwhile now it is not yet clear to me what should be done for driver which
> supports MAC-based ACL, but not full-fledged AP SME.

Are you sure that such a device can even exist? It'd have to drop the
auth frames, so they can't be handled by the host? Is there much point
in that?

johannes

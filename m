Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55482 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1765528AbcJaKds (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 06:33:48 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>,
        "abhishekbh@google.com" <abhishekbh@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH v4 1/3] mwifiex: reset card->adapter during device
 unregister
Date: Mon, 31 Oct 2016 10:33:42 +0000
Message-ID: <2cd24d83a63e41189c121f66fff4fc44@SC-EXCH04.marvell.com> (sfid-20161031_113351_766916_2C63DF8F)
References: <1475777186-20486-1-git-send-email-akarwar@marvell.com>
 <20161010205332.GB11254@localhost> <20161011002238.GC19969@localhost>
 <b1231f275ecc4e45a9c98dadb1d585f1@SC-EXCH04.marvell.com>
 <20161025005150.GA84310@google.com>
 <933ec70e65a6470ca0654d1a5b5c4496@SC-EXCH04.marvell.com>
 <20161025165429.GA64548@google.com>
In-Reply-To: <20161025165429.GA64548@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Tuesday, October 25, 2016 10:25 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; Xinming Hu; abhishekbh@google.com; Dmitry Torokhov
> Subject: Re: [PATCH v4 1/3] mwifiex: reset card->adapter during device
> unregister
> 

Please ignore this patch series (and also v5)
As Brian pointed out, it doesn't address race issues correctly. 
Xinming Hu has submitted a patch series(having 12 patches) from Brian which resolves the issues and performs some cleanup work.

Regards,
Amitkumar Karwar.

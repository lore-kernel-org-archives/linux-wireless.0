Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757787AbeD0LpW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 07:45:22 -0400
Date: Fri, 27 Apr 2018 14:44:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] rsi: fix a bug in rsi_hal_key_config()
Message-ID: <20180427114449.pil7fgddcvpapgrq@mwanda> (sfid-20180427_134526_258099_AF578E1B)
References: <20180427112130.GA27655@mwanda>
 <87o9i46g1n.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87o9i46g1n.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 27, 2018 at 02:32:20PM +0300, Kalle Valo wrote:
> 
> Gustavo submitted an identical patch also for this one :)
> 
> https://patchwork.kernel.org/patch/10365997/
> 

Hey Gustavo,

We keep on sending duplicate patches.  Most of the static checker people
CC kernel-janitors@vger.kernel.org so we can see what's already been
sent.

regards,
dan carpenter

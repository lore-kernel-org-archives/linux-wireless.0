Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54342 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752989AbdEIFdc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 01:33:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] net: wireless: ath: ath10k: remove unnecessary code
Date: Tue, 9 May 2017 05:33:28 +0000
Message-ID: <87lgq6387s.fsf@kamboji.qca.qualcomm.com> (sfid-20170509_073403_690192_BDB6C3B5)
References: <20170509042159.GA19727@embeddedgus>
In-Reply-To: <20170509042159.GA19727@embeddedgus> (Gustavo A. R. Silva's
        message of "Mon, 8 May 2017 23:21:59 -0500")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> writes:

> The name of an array used by itself will always return the array's addres=
s.
> So these tests will always evaluate as false and therefore the _return_
> will never be executed.
>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

I don't understand the commit log, especially what does "The name of an
array used by itself" mean?

--=20
Kalle Valo=

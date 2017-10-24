Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:64632 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdJXEvE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 00:51:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jasmine Strong <jas@eero.com>
CC: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: rebuild crypto header in RX data frames
Date: Tue, 24 Oct 2017 04:50:56 +0000
Message-ID: <8760b5cfnz.fsf@kamboji.qca.qualcomm.com> (sfid-20171024_065109_943972_74793CBB)
References: <150851690590.5158.11970481736247725763.stgit@potku.adurom.net>
        <c9bdd915-0667-eee0-3b52-1fdf15abf249@dd-wrt.com>
        <CAGyitvP0wquoo_8_ma3rcj+riJ5Wgfo7+pmbUOx9pQRwFcQHYA@mail.gmail.com>
        <87376dds5e.fsf@kamboji.qca.qualcomm.com>
        <9407ed1f-2bd9-3fd0-981d-1a20452e8ba9@dd-wrt.com>
        <CAGyitvNj+74HafQ9Aps1HTmknTxa0ZUgV7hao1A8mJ4rV7cibw@mail.gmail.com>
In-Reply-To: <CAGyitvNj+74HafQ9Aps1HTmknTxa0ZUgV7hao1A8mJ4rV7cibw@mail.gmail.com>       (Jasmine
 Strong's message of "Mon, 23 Oct 2017 11:28:18 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jasmine Strong <jas@eero.com> writes:

> That's what I saw.  A bcom client was able to associate and not pass
> any traffic.  This is on all three of 9882, 9888 and 4019.

Thanks for the report, we'll investigate it. And I see that your email
was now succesfully delivered to the list:

http://lists.infradead.org/pipermail/ath10k/2017-October/010325.html

--=20
Kalle Valo=

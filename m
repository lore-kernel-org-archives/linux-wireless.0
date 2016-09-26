Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:41397 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756047AbcIZSn0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 14:43:26 -0400
Message-ID: <1474915401.2238.21.camel@perches.com> (sfid-20160926_204351_064256_A331334D)
Subject: Re: hostap: Delete an unnecessary jump label in
 prism2_ioctl_priv_hostapd()
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Mon, 26 Sep 2016 11:43:21 -0700
In-Reply-To: <87mviuy0b7.fsf@kamboji.qca.qualcomm.com>
References: <65ed528f-7ec5-a0f2-6219-3e63a78ca0ee@users.sourceforge.net>
         <20160926150656.213D961568@smtp.codeaurora.org>
         <88d5023a-9a59-ab36-8c6c-a146cae803b5@users.sourceforge.net>
         <874m52zgjy.fsf@kamboji.qca.qualcomm.com>
         <1474913885.2238.19.camel@perches.com>
         <87mviuy0b7.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-09-26 at 21:37 +0300, Kalle Valo wrote:
> I talked with Jouni and we concluded marking this fully obsolete is the
> best (so removing the "Maintained" part completelo the shmoo list
> is not used anymore, that can be removed.

Well, it would be best if Jouni submitted something.

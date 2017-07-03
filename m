Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35055 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755788AbdGCRu7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jul 2017 13:50:59 -0400
Received: by mail-io0-f182.google.com with SMTP id h134so60440607iof.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jul 2017 10:50:58 -0700 (PDT)
Date: Mon, 3 Jul 2017 12:50:55 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Vasiliy Safronov <vvsprog@gmail.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: Update regulatory rules for Kazakhstan (KZ) on 5GHz
Message-ID: <20170703175055.tnnweqg2uyyw2rnc@ubuntu-xps13> (sfid-20170703_195110_995519_6CAE58D7)
References: <CALfe80gmDFDnvT=MvN8891wudBEAmeQpH1X1_wNzQpkhbLSOVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALfe80gmDFDnvT=MvN8891wudBEAmeQpH1X1_wNzQpkhbLSOVQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 26, 2017 at 10:00:13AM +0600, Vasiliy Safronov wrote:
> Please add support 5ghz for Kazakhstan.
> In Kazakhstan there are no restrictions up to 100mW
> country KZ: DFS-ETSI
>  (2402 - 2482 @ 40), (20)
>  (5170 - 5250 @ 80), (20), AUTO-BW
>  (5250 - 5330 @ 80), (20), DFS, AUTO-BW
>  (5650 - 5730 @ 80), (30), DFS
>  (5735 - 5835 @ 80), (30)
> 
> http://adilet.zan.kz/rus/docs/P000001379_
> S 5.282 etc

Thanks for the submission, and apologies for the slow response. I've
been trying to find some time to validate the changes against the
document you linked to but haven't managed to get it done yet. I hope to
be able to take a look at this soon.

Thanks,
Seth

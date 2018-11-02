Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDB6C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 09:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1BA82081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 09:12:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1BA82081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbeKBSS7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 14:18:59 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:33934 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbeKBSS7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 14:18:59 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIVVA-0007JU-SC; Fri, 02 Nov 2018 11:12:25 +0200
Message-ID: <09f6ce3a819b2b9d29e056baa5707c36cf3b1342.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Michael =?ISO-8859-1?Q?K=F6bberich?= 
        <michael.koebberich@erdw.ethz.ch>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
Date:   Fri, 02 Nov 2018 11:12:23 +0200
In-Reply-To: <005001d47288$bf86fac0$3e94f040$@erdw.ethz.ch>
References: <005001d47288$bf86fac0$3e94f040$@erdw.ethz.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: iwlwifi firmware
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Michael,

On Fri, 2018-11-02 at 09:47 +0100, Michael Köbberich wrote:
> Sehr geehrtes Intel Team
> 
> Ich bin auf der Suche nach Firmware für einen Axxiv FIN NUC DH17012,
> genauer gesagt dessen WIFI Karte. Sind die Treiber:
> 
> iwlwifi-8000C-26.ucode
> iwlwifi-8000C-25.ucode
> iwlwifi-8000C-24.ucode
> iwlwifi-8000C-23.ucode
> iwlwifi-8000C-22.ucode
> iwlwifi-8000C-21.ucode
> iwlwifi-8000C-20.ucode
> iwlwifi-8000C-19.ucode
> iwlwifi-8000C-18.ucode
> iwlwifi-8000C-17.ucode
> 
> bei Ihnen erhältlich?

I sort of understood what you wrote in German, but excuse me for
replying in English.

All our public firmwares are available here:

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/


Not all versions supported by the driver are released publicly, so you
may get some warnings about missing files, but they are not mandatory,
the driver only needs one of them (and chooses the highest version
available).  So if you're seeing messages about missing firmwares, but
your card works anyway, you can ignore them.

HTH.

--
Cheers,
Luca.


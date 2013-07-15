Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:43700 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3GOTGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 15:06:34 -0400
Received: by mail-lb0-f175.google.com with SMTP id r10so9694465lbi.34
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jul 2013 12:06:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373601613-31616-1-git-send-email-sujith@msujith.org>
References: <1373601613-31616-1-git-send-email-sujith@msujith.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 15 Jul 2013 12:06:12 -0700
Message-ID: <CAB=NE6V6n9ZA2606Bje4bACNoEEQDSy_Sdtq4chVOSz9tL3bEQ@mail.gmail.com> (sfid-20130715_210643_426808_94597E36)
Subject: Re: [PATCH 0/6] initval patches
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 11, 2013 at 9:00 PM, Sujith Manoharan <sujith@msujith.org> wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> This is a resend of the pending initval patches, rebased over
> master.
>
> Sujith Manoharan (6):
>   initvals: Update inivals for AR9462 2.0
>   initvals: Add 5g-XLNA table for AR9462
>   initvals: Add ar9462_2p0_5g_xlna_only_rxgain table
>   initvals: Add rxgain tables for AR9462
>   initvals: Add support for AR9462 2.1
>   initvals: Add mix ob/db tx gain table for AR9462 2.0

Thanks, applied and pushed!

  Luis

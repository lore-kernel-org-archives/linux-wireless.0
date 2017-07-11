Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ecemailfilter.ece.umd.edu ([129.2.90.4]:52117 "EHLO
        mailfilter.ece.umd.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754931AbdGKO4V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 10:56:21 -0400
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com [209.85.220.197]) by mailfilter.ece.umd.edu with ESMTP id RpYOz6386Y6An4nJ for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 10:56:20 -0400 (EDT)
Received: by mail-qk0-f197.google.com with SMTP id a195so1398568qkb.13
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 07:56:20 -0700 (PDT)
Date: Tue, 11 Jul 2017 10:56:17 -0400
From: "S. Gilles" <sgilles@math.umd.edu>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [BUG] brcmfmac: BRCM4354 cannot connect since commit 270a6c1f65
Message-ID: <20170711145617.puao7oybvpv3it72@number18.npnth.net> (sfid-20170711_165625_554602_B17F3A39)
References: <20170711122125.5epcjhcyneiwxyse@number18.npnth.net>
 <d5775426-f1bd-c2ce-89a8-e11472815787@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <d5775426-f1bd-c2ce-89a8-e11472815787@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-07-11T14:35:07+0200, Arend van Spriel wrote:
> [...]
> 
> Looking at the diff of the bad commit, I came up with the patch below.
> Can you try it and let me know the result?

That seems to fix everything for me, thanks for the quick patch!

Thanks,
S. Gilles

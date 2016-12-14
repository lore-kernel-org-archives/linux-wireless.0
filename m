Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:33904 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbcLNGG3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 01:06:29 -0500
Received: by mail-qk0-f175.google.com with SMTP id q130so9422620qke.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2016 22:06:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=iLryhOS--PPYCGa9pE2GovPDOXi6xoH22xFOYXXKNVA@mail.gmail.com>
References: <583DD564.8040704@cococorp.com> <20161201070908.GB11953@atheros-ThinkPad-T61>
 <58421FA2.2020004@cococorp.com> <20161203124358.GB31861@atheros-ThinkPad-T61>
 <20161203124600.GC31861@atheros-ThinkPad-T61> <5845B325.6060002@cococorp.com>
 <d8eb0ba5828d43dd83030247ba443b88@aphydexm01f.ap.qualcomm.com>
 <58472E7B.7090603@cococorp.com> <58504113.2080702@cococorp.com>
 <5850831D.7020206@cococorp.com> <ccf17009a52748c99accdaa005ea837a@NALASEXR01H.na.qualcomm.com>
 <CAAnMG+OmeataRKYRjOjtBXF_1-De-F4zWbUsWoYRhVu02NPrrw@mail.gmail.com> <CAJ-Vmo=iLryhOS--PPYCGa9pE2GovPDOXi6xoH22xFOYXXKNVA@mail.gmail.com>
From: Alexis Green <agreen@cococorp.com>
Date: Tue, 13 Dec 2016 22:06:27 -0800
Message-ID: <CAAnMG+MY=LhfJxxUVdfRNYUW-2R+EXdLm2o6yDcCH0T1brRVxw@mail.gmail.com> (sfid-20161214_070633_465751_B84A47FD)
Subject: Re: ath10k firmware crashes in mesh mode on QCA9880
To: Adrian Chadd <adrian@freebsd.org>
Cc: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
        Benjamin Morgan <bmorgan@cococorp.com>,
        "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>,
        Mohammed Shafi Shajakhan <mohammed@codeaurora.org>,
        "lede-dev@lists.infradead.org" <lede-dev@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

I have not done much testing of ath10k and ath9k devices in a single
encrypted mesh recently, but I have a memory of only having this issue
when communicating between ath10k devices.

Alexis

On Tue, Dec 13, 2016 at 9:53 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi!
>
> Hm! So is there a firmware bug if there are 11n only capable nodes in
> an 11s mesh?
>
>
>
> -adrian

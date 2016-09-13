Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34503 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752626AbcIMN5T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 09:57:19 -0400
Received: by mail-vk0-f43.google.com with SMTP id v189so178277902vkv.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2016 06:57:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bmztm8qm.fsf@kamboji.qca.qualcomm.com>
References: <1470140454-3899-1-git-send-email-bartosz.markowski@tieto.com>
 <1470140454-3899-3-git-send-email-bartosz.markowski@tieto.com> <87bmztm8qm.fsf@kamboji.qca.qualcomm.com>
From: Bartosz Markowski <bartosz.markowski@tieto.com>
Date: Tue, 13 Sep 2016 15:57:17 +0200
Message-ID: <CACKGw+FAwPb2NLW5G8CnGH4X2eCCjUkuJwLoqW9w9rKpDuQJDw@mail.gmail.com> (sfid-20160913_155722_626272_EBF8255A)
Subject: Re: [PATCH 2/2] ath10k: add platform regulatory domain support
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 September 2016 at 17:35, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:

[...]

> > +#ifdef CONFIG_ACPI
> > +#define WRD_METHOD "WRDD"
> > +#define WRDD_WIFI  (0x07)
> > +
> > +static u32 ath10k_mac_wrdd_get_mcc(struct ath10k *ar, union acpi_object *wrdd)
> > +{
>
> I don't think the ifdef is really necessary, acpi.h should handle that
> (hopefully). Also I changed the error handling to use standard error
> values and changed the info messages to dbg, they are too spammy in my
> opinion. Please check carefully my changes in the pending branch:
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=fe91745381ec3999d8de6dedb07b396c82539717

I'm OK with the changes, I have not tried that though, except of
reviewing and compiling it (do not have access to the chromebook for
next few days). If you want to wait with it until I test it, it's fine
too.

Bartosz

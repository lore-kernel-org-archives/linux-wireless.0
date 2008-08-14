Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.239]:48925 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759507AbYHNSgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 14:36:19 -0400
Received: by wx-out-0506.google.com with SMTP id h29so748628wxd.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 11:36:17 -0700 (PDT)
Message-ID: <43e72e890808141136o489821bej884372b8da9d34ac@mail.gmail.com> (sfid-20080814_203637_653634_35C58802)
Date: Thu, 14 Aug 2008 11:36:16 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: [RFC] mac80211: scan result IEs in one block
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080814181335.GB7998@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080814174709.GA7998@jm.kir.nu> <20080814181335.GB7998@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 14, 2008 at 11:13 AM, Jouni Malinen <j@w1.fi> wrote:

> +       if (bss->ies == NULL || bss->ies_len < elems->total_len) {
> +               kfree(bss->ies);
> +               bss->ies = kmalloc(elems->total_len, GFP_ATOMIC);

Typo here on check for NULL ?

  Luis

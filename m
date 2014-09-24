Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54383 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIXG65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 02:58:57 -0400
Received: by mail-wi0-f174.google.com with SMTP id fb4so6266288wid.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 23:58:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140923143219.23585.34114.stgit@potku.adurom.net>
References: <20140923143219.23585.34114.stgit@potku.adurom.net>
Date: Wed, 24 Sep 2014 08:58:56 +0200
Message-ID: <CA+BoTQ=P2mKLbdPTQYM_c-ohMtsucTHbc_aukzqcdpQUwhwtvQ@mail.gmail.com> (sfid-20140924_085901_834071_6FFF13EB)
Subject: Re: [PATCH v2 1/3] ath10k: don't enable interrupts for the diagnostic window
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 September 2014 16:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
> -       for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
> +       /* Skip the last copy engine, CE7 the diagnostic window, as that
> +        * uses polling and isn't initialized for interrupts. */

Comment style :-)


Michał

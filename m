Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbdGYMzo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 08:55:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: sgruszka@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Constify attribute_group structures
References: <1499758370-24871-1-git-send-email-arvind.yadav.cs@gmail.com>
Date: Tue, 25 Jul 2017 15:55:40 +0300
In-Reply-To: <1499758370-24871-1-git-send-email-arvind.yadav.cs@gmail.com>
        (Arvind Yadav's message of "Tue, 11 Jul 2017 13:02:48 +0530")
Message-ID: <87fudkiskz.fsf@codeaurora.org> (sfid-20170725_145614_210828_5C260888)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arvind Yadav <arvind.yadav.cs@gmail.com> writes:

> attribute_groups are not supposed to change at runtime. So mark the
> non-const structs as const.
>
> Arvind Yadav (10):
>   [PATCH v2 01/10] net: cdc_ncm: constify attribute_group structures.
>   [PATCH v2 02/10] net: can: at91_can: constify attribute_group structures.
>   [PATCH v2 03/10] net: can: janz-ican3: constify attribute_group structures.
>   [PATCH v2 04/10] wireless: ipw2200: constify attribute_group structures.
>   [PATCH v2 05/10] wireless: ipw2100: constify attribute_group structures.
>   [PATCH v2 06/10] wireless: iwlegacy: constify attribute_group structures.
>   [PATCH v2 07/10] wireless: iwlegacy: Constify attribute_group structures.
>   [PATCH v2 08/10] arcnet: com20020-pci: constify attribute_group structures.
>   [PATCH v2 09/10] net: bonding: constify attribute_group structures.
>   [PATCH v2 10/10] net: chelsio: cxgb3: constify attribute_group structures.

Via which tree were you planning to push these? Is it ok if I take the
wireless patches to my tree?

-- 
Kalle Valo

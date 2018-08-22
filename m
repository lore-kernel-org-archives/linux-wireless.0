Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbeHVPB5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 11:01:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v2 05/17] iwlwifi: add d3 debug data support
References: <20180821050952.31603-1-luca@coelho.fi>
        <20180821050952.31603-6-luca@coelho.fi>
Date: Wed, 22 Aug 2018 14:37:19 +0300
In-Reply-To: <20180821050952.31603-6-luca@coelho.fi> (Luca Coelho's message of
        "Tue, 21 Aug 2018 08:09:40 +0300")
Message-ID: <87bm9ur5sg.fsf@kamboji.qca.qualcomm.com> (sfid-20180822_133726_877091_E6E9C122)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Shahar S Matityahu <shahar.s.matityahu@intel.com>
>
> During d3, the firmware records debug data into internal buffer
> if debug data collection occurs, collect the data that was written to the
> buffer
>
> Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

[...]

> --- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
> +++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
> @@ -8,6 +8,7 @@
>   * Copyright(c) 2014 Intel Corporation. All rights reserved.
>   * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
>   * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
> + * Copyright (C) 2018 Intel Corporation
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of version 2 of the GNU General Public License as
> @@ -18,11 +19,6 @@
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>   * General Public License for more details.
>   *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
> - * USA
> - *
>   * The full GNU General Public License is included in this distribution
>   * in the file called COPYING.
>   *

Is this removal intentional? Just curious.

-- 
Kalle Valo

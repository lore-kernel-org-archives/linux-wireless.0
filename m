Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:41725 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYEJJVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 05:21:09 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2273282waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 02:21:07 -0700 (PDT)
Message-ID: <1ba2fa240805100221g3acde8btd3d9999569e78823@mail.gmail.com> (sfid-20080510_112130_604200_A3401829)
Date: Sat, 10 May 2008 12:21:06 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Huang Weiyi" <weiyi.huang@gmail.com>
Subject: Re: iwl-sta.c: removed duplicated include
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080510091004.2451.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080510091004.2451.WEIYI.HUANG@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 10, 2008 at 4:11 AM, Huang Weiyi <weiyi.huang@gmail.com> wrote:
> Removed duplicated include "iwl-sta.h" in
> drivers/net/wireless/iwlwifi/iwl-sta.c
>
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
>
> --- a/drivers/net/wireless/iwlwifi/iwl-sta.c    2008-05-10 08:50:32.000000000 +0800
> +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c    2008-05-10 08:50:46.000000000 +0800
> @@ -36,7 +36,6 @@
>  #include "iwl-io.h"
>  #include "iwl-helpers.h"
>  #include "iwl-4965.h"
> -#include "iwl-sta.h"
>
>  int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
>  {
>
What is this for?

Tomas

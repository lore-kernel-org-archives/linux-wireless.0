Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:49920 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3GBFDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 01:03:51 -0400
Received: by mail-la0-f46.google.com with SMTP id eg20so5208987lab.33
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jul 2013 22:03:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372075552-3253-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1372075552-3253-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Tue, 2 Jul 2013 08:03:50 +0300
Message-ID: <CANUX_P0QFVzdM_Vk4aUHrHSrdxRdTL7tkrD1GiSb9BtmLx5n5g@mail.gmail.com> (sfid-20130702_070355_340769_594F8573)
Subject: Re: [PATCH] iwlwifi: add firmware for 7260 / 3160 devices
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bjorn Mork <bjorn@mork.no>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 24, 2013 at 3:05 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> Add new firmware for new devices: 7260 and 3160
> version:
> 22.0.7.0
>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  LICENCE.iwlwifi_firmware |    2 +-
>  WHENCE                   |    6 ++++++
>  iwlwifi-3160-7.ucode     |  Bin 0 -> 670172 bytes
>  iwlwifi-7260-7.ucode     |  Bin 0 -> 682892 bytes
>  4 files changed, 7 insertions(+), 1 deletion(-)
>  create mode 100644 iwlwifi-3160-7.ucode
>  create mode 100644 iwlwifi-7260-7.ucode
>

ping? :)

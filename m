Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:51560 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3IJLac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:30:32 -0400
Received: by mail-la0-f52.google.com with SMTP id ev20so5981771lab.39
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 04:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <00b201ceae17$2e5c3a00$8b14ae00$%han@samsung.com>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
	<00b201ceae17$2e5c3a00$8b14ae00$%han@samsung.com>
Date: Tue, 10 Sep 2013 14:30:31 +0300
Message-ID: <CANUX_P3YqAfpEgWSp2ha8qWTm84M48cBvMDdTtOs7evMhm0tdw@mail.gmail.com> (sfid-20130910_133035_924377_9F783E7D)
Subject: Re: [PATCH 01/12] wireless: iwlwifi: remove unnecessary pci_set_drvdata()
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 2:16 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/net/wireless/iwlwifi/pcie/drv.c |    3 ---
>  1 file changed, 3 deletions(-)
>

I picked it up - thanks.

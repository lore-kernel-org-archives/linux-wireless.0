Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:62530 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbYEHIxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 04:53:21 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1010595waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 01:53:20 -0700 (PDT)
Message-ID: <1ba2fa240805080153u41af3bb3o8e5e9bf95b16793d@mail.gmail.com> (sfid-20080508_105235_853563_AA69C667)
Date: Thu, 8 May 2008 11:53:20 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2.6.26] iwlwifi: Fix frequency in rx_status fill
Cc: linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	"David Miller" <davem@davemloft.net>, "Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1210217645-17474-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210217645-17474-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 8, 2008 at 6:34 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
>  This patch fixes a bug in RX path, the frequency was wrongly set in the
>  ieee80211_rx_status. This bug led to an empty scan list in A band.
>
>  Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>  Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>  --
-
John
This is an important bug fix also for 26

Thanks
Tomas
>

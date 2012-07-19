Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63468 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSTyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 15:54:39 -0400
Received: by pbbrp8 with SMTP id rp8so4851414pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2012 12:54:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120719130056.22047.19196.stgit@x201>
References: <20120719125937.22047.91375.stgit@x201> <20120719130056.22047.19196.stgit@x201>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 19 Jul 2012 12:54:18 -0700
Message-ID: <CAB=NE6UTDeYowTXdZ-2uGzQgQ3MWxwg-xpYYXxbpT-J6iacjcg@mail.gmail.com> (sfid-20120719_215443_897813_FA5A0FF8)
Subject: Re: [PATCH v2 3/3] ath6kl: add support for changing contry code
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 19, 2012 at 6:00 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> To make it possible to change the country code from user space via nl80211
> add handler for reg_notifier. The feature is only enabled when built
> time option CONFIG_ATH6KL_REGDOMAIN is enabled, which again depends on
> CFG80211_CERTIFICATION_ONUS for certication purposes.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Ah OK so a followup patch would use ath6kl_wmi_set_regdomain_cmd() ?

  Luis

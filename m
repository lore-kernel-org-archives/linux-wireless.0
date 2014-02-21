Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:42339 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaBUXiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 18:38:06 -0500
Received: by mail-la0-f53.google.com with SMTP id e16so2913327lan.26
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 15:38:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392896671-4288-3-git-send-email-ilan.peer@intel.com>
References: <1392896671-4288-1-git-send-email-ilan.peer@intel.com> <1392896671-4288-3-git-send-email-ilan.peer@intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 15:37:44 -0800
Message-ID: <CAB=NE6WnLxMivDwtx_pfvfnH2CUJrvSoewLOR2hZsv+_kMmc9Q@mail.gmail.com> (sfid-20140222_003810_587424_2933A994)
Subject: Re: [PATCH v5 2/5] cfg80211: Add Kconfig option for cellular BS hints
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 3:44 AM, Ilan Peer <ilan.peer@intel.com> wrote:
> Move the regulatory cellular base station hints support under
> a specific configuration option and make the option depend
> on CFG80211_CERTIFICATION_ONUS.
>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis

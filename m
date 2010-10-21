Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62671 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0JUTO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 15:14:27 -0400
Received: by iwn34 with SMTP id 34so75210iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 12:14:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287616028-12547-6-git-send-email-lrodriguez@atheros.com>
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com> <1287616028-12547-6-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 21 Oct 2010 12:14:06 -0700
Message-ID: <AANLkTikMXV0AXgiNPGkJiNoEEgcdV8wbgHMQcH0ou-VW@mail.gmail.com>
Subject: Re: [PATCH 5/6] ath: add a ATH_DBG_WARN()
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 20, 2010 at 4:07 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> To be used to throw out warnings only for developers.
> This can be used by some corner cases that developers
> already know can be hit but developers want to address
> so to avoid spewing out a warning this can only be
> enabled with CONFIG_ATH_DEBUG enabled.
>
> Cc: Ben Greear <greearb@candelatech.com>
> Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Sorry, please use my v2.

  Luis

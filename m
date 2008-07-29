Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:18592 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYG2IIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 04:08:49 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3302292waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 01:08:49 -0700 (PDT)
Message-ID: <1ba2fa240807290108y5bdfce9co4b69b8e626199209@mail.gmail.com> (sfid-20080729_100857_234880_77D8C59A)
Date: Tue, 29 Jul 2008 11:08:49 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH 3/8] wireless: replace __FUNCTION__ with __func__
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, "Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1217311294.23389.26.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217311294.23389.26.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 9:01 AM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> __FUNCTION__ is gcc-specific, use __func__
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/net/wireless/airo.c                   |   16 ++++++++--------
>  drivers/net/wireless/hermes.c                 |    2 +-
>  drivers/net/wireless/ipw2100.c                |    2 +-
>  drivers/net/wireless/ipw2200.h                |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl-3945-debug.h |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl-debug.h      |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl3945-base.c   |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl4965-base.c   |    4 ++--
>  drivers/net/wireless/libertas/if_cs.c         |    2 +-
>  drivers/net/wireless/prism54/isl_ioctl.c      |    8 ++++----
>  drivers/net/wireless/rt2x00/rt2x00.h          |    4 ++--
>  drivers/net/wireless/wl3501_cs.c              |    8 ++++----
>  12 files changed, 31 insertions(+), 31 deletions(-)
>
I've already sumbitted patch for iwlwifi that also contains this fix.
I'm also the file iwl4965-base was renamed.  The updates to
wireless-testing are laginging  due to OLS for almost 2 weeks.

Tomas

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46971 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab0EMVyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:54:49 -0400
Received: by wwi18 with SMTP id 18so127022wwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 14:54:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
References: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
Date: Thu, 13 May 2010 23:54:47 +0200
Message-ID: <AANLkTilm7VDQkXBMWUeRtH634oq9i9AdUIsv6V3woRH_@mail.gmail.com>
Subject: Re: [PATCH 0/2] iwlwifi fixes for 2.6.34
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whats with "iwl3945: fix scan races"?

- Sedat -

[1] https://patchwork.kernel.org/patch/98326/

On Thu, May 13, 2010 at 11:49 PM, Reinette Chatre
<reinette.chatre@intel.com> wrote:
> We include two late fixes hoping to make it into 2.6.34.
>
> "iwlwifi: fix internal scan race" fixes a kernel crash caused by
> accessing a NULL pointer. More can be read in
> https://bugzilla.kernel.org/show_bug.cgi?id=15824
>
> "iwlagn: work around rate scaling reset delay" is already in
> wireless-next-2.6 but has since been shown to be an issue in 2.6.34 also.
> This fixes spurious firmware restarts that has been documented in
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2173 , but it is the
> community report tracked in
> https://bugzilla.kernel.org/show_bug.cgi?id=15782 that prompted us sending
> this fix to wireless-2.6 also.
>
> These patches are also available from wireless-2.6 branch on
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
>
> Reinette Chatre (2):
>  iwlwifi: fix internal scan race
>  iwlagn: work around rate scaling reset delay
>
>  drivers/net/wireless/iwlwifi/iwl-scan.c |   21 +++++++++++++++--
>  drivers/net/wireless/iwlwifi/iwl-sta.c  |   37 ++++++++++++++++++++++++++++++-
>  2 files changed, 54 insertions(+), 4 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

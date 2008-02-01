Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:50419 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbYBAT5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 14:57:34 -0500
Received: by wa-out-1112.google.com with SMTP id v27so871654wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 11:57:30 -0800 (PST)
Message-ID: <1ba2fa240802011157g5fc538edm7b625c999603e16f@mail.gmail.com> (sfid-20080201_195738_298699_3BAE95F1)
Date: Fri, 1 Feb 2008 21:57:30 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/2] iwlwifi: set rate_idx correctly from plcp
Cc: "Abbas, Mohamed" <mohamed.abbas@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <D936D925018D154694D8A362EEB08920038F3E76@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1201844801-7326-1-git-send-email-reinette.chatre@intel.com>
	 <1201844801-7326-2-git-send-email-reinette.chatre@intel.com>
	 <1ba2fa240802010343q519a1dap9d4af5ef5e0110f2@mail.gmail.com>
	 <33E1C72C74DBE747B7B59C1740F7443702C96D93@orsmsx417.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920038F3E76@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 7:40 PM, Chatre, Reinette <reinette.chatre@intel.com> wrote:
> On Friday, February 01, 2008 8:29 AM, Abbas, Mohamed  wrote:
>
> > From: Tomas Winkler [mailto:tomasw@gmail.com]
> > Sent: Friday, February 01, 2008 3:44 AM
> > On Feb 1, 2008 7:46 AM, Reinette Chatre
> > <reinette.chatre@intel.com> wrote:
> >> From: Mohamed Abbas <mohamed.abbas@intel.com>
> >>
> >> rate_idx is derived from plcp information
> >>
> >> Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
> >> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com> ---
> >>  drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
>
> [..snip..]
>
> > NACK
> > This should be
> > rate_idx =
> > iwl4965_rate_index_from_plcp(wl4965_hw_get_rate(rx_start->rate_
> > n_flags));
> >
> > iwl4965_hw_get_rate - this one extract plcp from rate_n_flags - also
> > takes care of endinaity Tomas
> >
> > Actually iwl4965_rate_index_from_plcp expect rate and flag
> > data to get the rate index.
> > Mohamed
>
> John,
>
> Sorry about the confusing emails - please go ahead and apply this patch.
>
> Thank you

Sorry it was my mistake.

> Reinette
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:44397 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbYFIUAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 16:00:08 -0400
Received: by rv-out-0506.google.com with SMTP id k40so490651rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 13:00:05 -0700 (PDT)
Message-ID: <c85cb4470806091300p61fc5c94l48a9667e1b6ff4f@mail.gmail.com> (sfid-20080609_220013_159081_C88909FD)
Date: Mon, 9 Jun 2008 23:00:05 +0300
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: CONFIG_IWL4965_HT=n in linux-next
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806090309y3fa65849l450df776b454f298@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080609015623.6bbc9d88.akpm@linux-foundation.org>
	 <1ba2fa240806090220y4a21d3d2k84143e2a4ee0cb1a@mail.gmail.com>
	 <20080609022341.16060b71.akpm@linux-foundation.org>
	 <1ba2fa240806090309y3fa65849l450df776b454f298@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_siso_to_other':
> >> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1439: error: 'struct iwl_priv' has no member named 'current_ht_config'
> >> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1443: error: 'struct iwl_priv' has no member named 'current_ht_config'
> >> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_mimo_to_other':
> >> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1530: error: 'struct iwl_priv' has no member named 'current_ht_config'
> >> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1534: error: 'struct iwl_priv' has no member named 'current_ht_config'
> >>
> >> It's a known issue.
> >
> > Sob.  Well please fix it urgently!  Poeple are trying to get work done
> > on top of linux-next.
> >
> I thought his is a development branch, everybody is on the edge today :)
>
> >> we are about to remove this conditional. Will
> >> happen till EOW.
> >
> >
> > I hacked around it:
> Why is not good just make it HT=y. Or you need it fixed for this
> random config files regression tests
> Anyway, if it's so urgent it will be done till EOD  (TMZ:GMT+2), hope
> it's good enough,
> Tomas
>

a patch removing this config has been issued (iwlwifi: removing
IWL4965_HT config)
Ron

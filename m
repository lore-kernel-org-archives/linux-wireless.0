Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaEGIDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 04:03:51 -0400
Message-ID: <1399449812.5038.5.camel@jlt4.sipsolutions.net> (sfid-20140507_100355_820585_C57F052D)
Subject: Re: [PATCH v4 3/5] mac80211: use chanctx reservation for STA CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 07 May 2014 10:03:32 +0200
In-Reply-To: <CA+BoTQnLh7Oq+40YfQtwhiDwNdaHN4sU_XSWZTr8EfVG421-HA@mail.gmail.com> (sfid-20140507_093509_515086_41CE6AE5)
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-4-git-send-email-michal.kazior@tieto.com>
	 <1399387428.4218.45.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnLh7Oq+40YfQtwhiDwNdaHN4sU_XSWZTr8EfVG421-HA@mail.gmail.com>
	 (sfid-20140507_093509_515086_41CE6AE5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 09:35 +0200, Michal Kazior wrote:

> >> Also remove the ieee80211_vif_change_channel()
> >> because it is no longer used.
> >
> > A lot of this looks really duplicated from the previous patch - since I
> > just merged the fixes is there really a need to go through the work etc.
> > and have this different, instead of going through cfg80211 for the
> > disconnect?
> 
> I'm not really sure what duplication you refer to? There were already
> a couple of uses of csa_connection_drop_work so I used it too. 

Yeah, never mind, I think I misinterpreted your patch.

> It
> might make sense now to use cfg80211_stop_iface() instead but I'd
> argue it's better to do that as a follow up patch.

Ok.

johannes


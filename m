Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2G0VQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 17:16:36 -0400
Received: by wgbdr13 with SMTP id dr13so3133295wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 14:16:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH] carl9170: Add support for NL80211_IFTYPE_MESH_POINT interfaces
Date: Fri, 27 Jul 2012 23:16:32 +0200
Cc: Javier Lopez <jlopex@cozybit.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <1343332743-11845-1-git-send-email-jlopex@cozybit.com> <201207271630.06025.chunkeey@googlemail.com> <CAPjQAd_Ko_WFEoG6uXk7hYYAggL6jbGiuKWdp=f3Aa+JdXNNJg@mail.gmail.com>
In-Reply-To: <CAPjQAd_Ko_WFEoG6uXk7hYYAggL6jbGiuKWdp=f3Aa+JdXNNJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201207272316.32411.chunkeey@googlemail.com> (sfid-20120727_231639_423994_77150BA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 July 2012 17:12:32 Javier Cardona wrote:
> On Fri, Jul 27, 2012 at 7:30 AM, Christian Lamparter wrote:
> > BTW: Did you do any experiments? I.e.: Does it really
> > work?
> 
> Basic peering and pinging with ath9k_htc seems to work.
> We only have one of these cards, so we cannot run our
> full test suite.  Testing will continue when we
> receive more cards.

Ok, thanks. I'll take care of updating the information
on the wiki now.

Regards,
	Chr

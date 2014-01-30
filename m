Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48802 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaA3STE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 13:19:04 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so7076921wgh.7
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jan 2014 10:19:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390426022.4334.50.camel@jlt4.sipsolutions.net>
References: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com> <1390426022.4334.50.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 30 Jan 2014 23:48:43 +0530
Message-ID: <CABPxzYK3pBK4QQh2W_vZbggkfszx+9d-zH+QC_uOXzDxfUMbUQ@mail.gmail.com> (sfid-20140130_191910_398646_86D9B239)
Subject: Re: [PATCH] minstrel_ht: Use RTS_CTS when STA is in DYNAMIC SMPS mode
 for frames sent using Nss>1.
To: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 23, 2014 at 2:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Wed, 2014-01-22 at 12:27 +0530, Chaitanya T K wrote:
>
> > +             if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
> > +                     minstrel_mcs_groups[i].streams > 1) {
> > +                     mi->tx_flags |= IEEE80211_TX_RC_USE_RTS_CTS;
> > +             } else if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
> > +                     minstrel_mcs_groups[i].streams > 1) {
>
> Your indentation is off inside the if statements. I'll have to wait for
> nbd to review the patch itself, I guess.
>
Felix,

 Any comments other than the indentation? If no, will send in the
v2 with indentation fixed.

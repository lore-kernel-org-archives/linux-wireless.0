Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:38954 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbYANT0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 14:26:44 -0500
Received: by py-out-1112.google.com with SMTP id u52so3233455pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2008 11:26:43 -0800 (PST)
Message-ID: <43e72e890801141126t21480e69wc024c2fdc236af52@mail.gmail.com> (sfid-20080114_192710_025697_BECBEE0E)
Date: Mon, 14 Jan 2008 14:26:42 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: rtl8187 rate control doesn't work
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	linux-kernel@vger.kernel.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4787F03E.6080605@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <477F9890.5050107@hauke-m.de>
	 <43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>
	 <47824D25.5090005@hauke-m.de>
	 <43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com>
	 <4787F03E.6080605@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 11, 2008 5:39 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Luis R. Rodriguez wrote:
> > On Jan 7, 2008 11:02 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> >
> > Thanks for reporting this, how'd it go with simple rate control
> > algorithm instead?
>
> How do I change from pid to simple rate control algorithm?

In config.mk replace this line:

CONFIG_MAC80211_RC_DEFAULT=pid

with:

CONFIG_MAC80211_RC_DEFAULT=simple

although I am planning on changing the config stuff soon.

  Luis

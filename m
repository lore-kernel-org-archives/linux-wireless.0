Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:45709 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXIMXeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 19:34:21 -0400
Received: by py-out-1112.google.com with SMTP id u77so1412776pyb
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2007 16:34:20 -0700 (PDT)
Message-ID: <43e72e890709131634r591b6db4u9f092470567b1cb@mail.gmail.com>
Date: Thu, 13 Sep 2007 19:34:20 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: remove turbo modes
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>, "Jiri Slaby" <jirislaby@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1189192606.28781.189.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1188485253.3978.22.camel@johannes.berg>
	 <43e72e890709071014w1f37b4acjac3c98c306a965de@mail.gmail.com>
	 <1189192606.28781.189.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/7/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-09-07 at 13:14 -0400, Luis R. Rodriguez wrote:
>
> > Can you elaborate a bit on what places (one would suffice) we should
> > be checking for them that would prevent failure so that we know where
> > to correct this later when we want to add support for these modes in
> > ath5k?
>
> There's the monitor stuff which certainly wasn't correct, turbo A surely
> uses OFDM/5GHz. Also, ISTR that there was something with turbo G not
> handled properly, but it's been a while, sorry.
>
> I'm not sure what we should do, I'm undecided about adding a whole bunch
> of proprietary rates back since these are basically only supported by
> one hardware. Let's discuss good ways to do this when you get around to
> it.

The last point I think is enough to give them the boot. Will post
patches based on this work with some small minor changes and also for
ath5k.

  Luis

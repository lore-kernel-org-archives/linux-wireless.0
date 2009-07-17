Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:34002 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934521AbZGQMuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 08:50:04 -0400
Received: by bwz28 with SMTP id 28so710539bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 05:50:03 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 0/5] mac80211: implement background scan
Date: Fri, 17 Jul 2009 14:50:10 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200907161104.41975.helmut.schaa@gmail.com> <1247779378.30529.46.camel@johannes.local> <200907162352.49020.helmut.schaa@gmail.com>
In-Reply-To: <200907162352.49020.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907171450.10699.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 16. Juli 2009 schrieb Helmut Schaa:
> Am Donnerstag, 16. Juli 2009 schrieb Johannes Berg:
> > On Thu, 2009-07-16 at 11:04 +0200, Helmut Schaa wrote:
> > 
> > > So, it would be great if somebody could test the patches on other
> > > hardware as well.
> > 
> > If you repost with the stuff we talked about fixed, I'll give them a
> > spin, but for all I can tell they should be good to go in, it's a huge
> > improvement and we can build on that.
> 
> Will do that soon. However, I still have an issue that sometimes
> the connection is stuck and I'm still unsure if it is related to the
> bg scan patches or something else :(

Ok, this is also reproducible without the bg scan patches by just using
sw scan together with iwlagn. Sometimes (I still have no clue under which
circumstances) just after a scan the connection is stuck while iwconfig
still shows association and also the signal levels are still updated.

Helmut


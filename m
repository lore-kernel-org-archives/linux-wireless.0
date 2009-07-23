Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54990 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZGWKs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:48:28 -0400
Received: by fxm18 with SMTP id 18so731559fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:48:27 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/7] mac80211: implement basic background scanning
Date: Thu, 23 Jul 2009 12:48:36 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20090723100732.5147.73989.stgit@localhost.localdomain> <20090723101411.5147.78380.stgit@localhost.localdomain> <1248345547.19121.23.camel@johannes.local>
In-Reply-To: <1248345547.19121.23.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907231248.36825.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 23. Juli 2009 schrieb Johannes Berg:
> On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> > Introduce a new scan flag "SCAN_BG_SCANNING" which basically tells us
> > that we are currently scanning but may as well be on the operating channel
> > to RX/TX data whereas "SCAN_SW_SCANNING" tells us that we are currently
> > on a different channel for scanning. While "SCAN_BG_SCANNING" is set
> > during the whole scan "SCAN_SW_SCANNING" is set when leaving the operating
> > channel and unset when coming back.
> 
> I think you got that description wrong :)

Argh, yes. Should I respin the whole series?

> > + * @SCAN_SW_SCANNING: We're currently in the process of scanning but may as
> > + *	well be on the operating channel
> > + * @SCAN_HW_SCANNING: The hardware is scanning for us, we have no way to
> > + *	determine if we are on the operating channel or not
> > + * @SCAN_OFF_CHANNEL: We're off our operating channel for scanning,
> > + *	gets only set in conjunction with SCAN_SW_SCANNING
> 
> johannes
> 



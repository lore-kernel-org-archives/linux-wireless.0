Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46815 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab0JZKEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 06:04:47 -0400
Received: by bwz11 with SMTP id 11so3201480bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 03:04:46 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Question about starting up an AP
Date: Tue, 26 Oct 2010 12:04:01 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Joshua Smith <JoshuaESmith@charter.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201010261135.31232.helmut.schaa@googlemail.com> <1288086094.3761.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1288086094.3761.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010261204.01481.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 26 Oktober 2010 schrieb Johannes Berg:
> On Tue, 2010-10-26 at 11:35 +0200, Helmut Schaa wrote:
> 
> > > I'll let Ivo decide on this. At least if we really want to wait more then one
> > > second for DMA to be ready we should increase the msleep(1) to msleep(10) and
> > > keep the maximum number of retries at 100.
> 
> > Ivo, do we want to add the excessive waiting (up to one second) for DMA on
> > rt2800 as it fixes Joshuas device? At the moment we're waiting 100ms.
> 
> I don't usually chime in on other drivers but is there any reason not
> to? Properly functioning devices obviously reply within 100ms, so they
> wouldn't change behaviour, hopefully broken ones that _never_ work are
> rare, and the remaining ones like Joshua's would be fixed ...

True, nevertheless I wanted to get Ivos ack before going ahead.

Helmut

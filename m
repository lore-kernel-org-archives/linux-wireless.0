Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39239 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZHRSFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 14:05:00 -0400
Received: by ewy3 with SMTP id 3so1806672ewy.18
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 11:05:00 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00: configure_filter() callback is allowed to sleep
Date: Tue, 18 Aug 2009 20:04:58 +0200
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200908181954.23419.IvDoorn@gmail.com> <1250618324.9886.25.camel@johannes.local>
In-Reply-To: <1250618324.9886.25.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200908182004.58584.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 18 August 2009, Johannes Berg wrote:
> On Tue, 2009-08-18 at 19:54 +0200, Ivo van Doorn wrote:
> > The configure_filter() callback function no longer needs
> > to be atomic. Remove the scheduled work structure and
> > call into the driver configure_filter() directly.
> 
> Nice, yeah, I didn't want to do that myself :)
> 
> Speaking of which -- bss_info_changed can sleep too, which means you can
> remove DRIVER_REQUIRE_SCHEDULED completely I think?

Seriously, that would be great. Patch coming up in a few minutes. ;)

Ivo

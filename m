Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:39832 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab1CCOcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 09:32:00 -0500
Date: Thu, 3 Mar 2011 14:31:51 +0000
From: Tony Houghton <h@realh.co.uk>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil@venema.h4ckr.net, Vivek Natarajan <vnatarajan@atheros.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
Message-ID: <20110303143151.03dbe76b@toddler>
In-Reply-To: <AANLkTinEA2NVxwWZJME-oChE6OEJc_TSTajMfe7f+3hm@mail.gmail.com>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
	<AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
	<20110225165745.4860afe0@realh.co.uk>
	<20110226183542.75bc1786@realh.co.uk>
	<AANLkTi=ZWmWZWMBSdGX8S9EfiRyv3eKEU9P3n0bfDAuJ@mail.gmail.com>
	<20110302163051.425d1419@toddler>
	<AANLkTinEA2NVxwWZJME-oChE6OEJc_TSTajMfe7f+3hm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 3 Mar 2011 10:51:15 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> On Wed, Mar 2, 2011 at 10:00 PM, Tony Houghton <h@realh.co.uk> wrote:
> >
> > Is this still not reproducible? I'd like to do more to help trace
> > the problem but I'm a bit stuck. Is there something I can do to
> > make sure all the debug/log messages from ath9k appear on the
> > console?
> 
> sudo dmesg -n 8?

AFAICT that will just make sure the debug messages get logged, but not
make them appear anywhere the other messages aren't appearing eg on a
console or net console. I could try tail -f /dev/xconsole.

The ath9k module has a "debug" parameter. It just says it's a mask and I
don't know how to use it. Do I set bits to enable or disable levels?
What value to log "everything"?

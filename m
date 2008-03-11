Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:51433 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYCKXJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 19:09:41 -0400
Received: by fk-out-0910.google.com with SMTP id z23so2489822fkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 16:09:39 -0700 (PDT)
To: Franz Apeltauer <franz.apeltauer@gmx.at>
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
Date: Wed, 12 Mar 2008 00:09:14 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <47CB3B5E.4020701@gmx.at> <200803112322.45274.IvDoorn@gmail.com> <47D70F5C.7020208@gmx.at>
In-Reply-To: <47D70F5C.7020208@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803120009.15002.IvDoorn@gmail.com> (sfid-20080311_230945_236383_68AA5046)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 March 2008, Franz Apeltauer wrote:
> Ivo van Doorn schrieb:
> > rt2500pci should work with adhoc and master mode, I have to note that
> > with versions up to 2.6.25 this is disabled due to lack of testing.
> > I don't know which rt2x00 version is packaged in the tarball, but if it
> > is older then 2.1.0 then adhoc and master mode is disabled in the driver.
> > 
> > Also note that although it is currently enabled, I still have not
> > received test reports about it, so I cannot claim that it is working.
> > 
> > Ivo
> > 
> Found in rt2x00.h: #define DRV_VERSION    "2.1.3"

Hmm, thats odd. It should at least support adhoc.
(Master mode depends on mac80211, regular mac80211 versions found
in the kernel don't support it yet, and they need patches from
Johannes Berg).

Does 'dmesg' indicate anything?

> I am far away from being a wlan expert or kernel hacker.
> But if that helps, I am willing to run any test you want on
> Ubuntu gutsy, kernel 2.6.22.

Ivo

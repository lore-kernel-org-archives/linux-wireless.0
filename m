Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:56546 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab1CASM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 13:12:29 -0500
Subject: Powersave broken on p54
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 19:12:22 +0100
Message-ID: <1299003142.6461.12.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using compat-wireless-2011-02-25 on my p54-spi device (n810).
Powersave is pretty much completely broken with this release.
With an older release from several weeks ago it used to work, though.

As soon as I enable PS, the link gets horrible latencies of
about 20 seconds or more per ping packet, for example.
It also saves hardly any power. (measured on the power supply).

Any ideas what could go wrong here?

-- 
Greetings Michael.


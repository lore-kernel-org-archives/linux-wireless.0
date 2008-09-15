Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.224]:53672 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYIODUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2008 23:20:51 -0400
Received: by qb-out-0506.google.com with SMTP id f11so3268086qba.17
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2008 20:20:50 -0700 (PDT)
Message-ID: <415f2dc40809142020n5647007bm6538158317817c01@mail.gmail.com> (sfid-20080915_052135_776901_58F569D6)
Date: Sun, 14 Sep 2008 23:20:50 -0400
From: "Brian Prodoehl" <bprodoehl@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: ath5k, higher bitrates (>24M) not working in IBSS mode
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm testing the driver (2008-09-12 compat-wireless-old snapshot) doing
point to point communication in ad-hoc mode with some XR2's (AR5414)
on an ixp425 platform running kernel 2.6.25.1.  "iwlist scanning"
reports RSSI around -30dBm.  I'm setting the bitrate with iwconfig,
and all rates from 1M to 24M work beautifully, but if I set the rate
to 36M, 48M or 54M, absolutely no data gets through at those rates.
Its not like it gets really lossy or anything, absolutely nothing
(except broadcasts) get through.

It seems reminiscent of this thread:
http://kerneltrap.org/mailarchive/linux-ath5k-devel/2007/11/2/380573

Does anyone have these rates working with ath5k in ad-hoc mode?

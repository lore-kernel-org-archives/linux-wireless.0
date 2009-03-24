Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f208.google.com ([209.85.217.208]:44832 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762164AbZCXQ7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 12:59:55 -0400
Received: by gxk4 with SMTP id 4so6663115gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 09:59:53 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Mar 2009 12:59:52 -0400
Message-ID: <c03d7e680903240959s51aa4864uaad281bd7487e823@mail.gmail.com> (sfid-20090324_175959_915963_BA6CE1F9)
Subject: Adhoc-demo support in mac80211
From: ming li <mingli@cs.umass.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Folks,

I am wondering how hard it is to add support for ahdemo mode in mac80211.
My understanding of ahdemo is that it does not have the beacons or the
association process as in adhoc mode. Does this mean that I can just
comment out the beacon and association code of adhoc mode and make it
ahdemo? Any info will be highly appreciated.

Thanks,

Ming

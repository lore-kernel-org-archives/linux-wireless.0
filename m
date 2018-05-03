Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ol.sdf.org ([205.166.94.20]:49400 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751713AbeECAjs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 20:39:48 -0400
Received: from sdf.org (sverige.freeshell.org [205.166.94.5])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id w430V7lV016449
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits) verified NO)
        for <linux-wireless@vger.kernel.org>; Thu, 3 May 2018 00:31:07 GMT
Received: (from gerrit@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id w430V6Nb001048
        for linux-wireless@vger.kernel.org; Wed, 2 May 2018 18:31:07 -0600 (MDT)
Date: Wed, 2 May 2018 18:31:06 -0600
From: Gerrit Renker <gerrit@SDF.ORG>
To: linux-wireless@vger.kernel.org
Subject: Intel 9260NGW (beacon) signal average values off
Message-ID: <20180503003106.GA19935@SDF.ORG> (sfid-20180503_023951_790849_8466E97A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A user with 4.15.11-1~bpo9+1 Debian kernel reported the following problem with
Intel 9260NGW in a Dell XPS 13: the following nl80211 reported values were off [1]:

 * signal average (NL80211_STA_INFO_SIGNAL_AVG) reported as +72 dBm
 * beacon signal average (NL80211_STA_INFO_BEACON_SIGNAL_AVG) reported as +184 dBm
 * while the station signal was reported as -74 dBm

I found a work-around in user-space, not sure if this has been fixed already.

Gerrit

 [1] https://github.com/uoaerg/wavemon/issues/47

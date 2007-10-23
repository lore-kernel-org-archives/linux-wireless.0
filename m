Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:65352 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbXJWHy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 03:54:27 -0400
Received: by py-out-1112.google.com with SMTP id u77so2983754pyb
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2007 00:54:26 -0700 (PDT)
Message-ID: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com> (sfid-20071023_085431_477987_08203BB8)
Date: Tue, 23 Oct 2007 09:54:25 +0200
From: dragoran <drago01@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: iwl3945/mac80211 cannot connect to dynamic wep network
Cc: ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to connect to a dynamic wep network using iwl3945 and
mac80211 I get this errors in dmesg and it fails to acciotate:
-----
eth1: Initial auth_alg=0
eth1: authenticate with AP 00:00:00:00:00:00
eth1: privacy configuration mismatch and mixed-cell disabled - disassociate
eth1: Initial auth_alg=0
eth1: authenticate with AP 00:01:f4:75:16:74
eth1: privacy configuration mismatch and mixed-cell disabled - disassociate
eth1: RX authentication from 00:01:f4:75:16:74 (alg=0 transaction=2 status=0)
eth1: authenticated
eth1: associate with AP 00:01:f4:75:16:74
eth1: mismatch in privacy configuration and mixed-cell disabled -
abort association
eth1: privacy configuration mismatch and mixed-cell disabled - disassociate
eth1: Initial auth_alg=0
eth1: authenticate with AP 00:01:f4:75:16:74
eth1: privacy configuration mismatch and mixed-cell disabled - disassociate
eth1: Initial auth_alg=0
eth1: authenticate with AP 00:01:f4:75:16:74
eth1: privacy configuration mismatch and mixed-cell disabled - disassociate
eth1: RX disassociation from 00:01:f4:75:16:74 (reason=7)
eth1: RX authentication from 00:01:f4:75:16:74 (alg=0 transaction=2 status=0)
eth1: authenticated
eth1: associate with AP 00:01:f4:75:16:74
eth1: mismatch in privacy configuration and mixed-cell disabled -
abort association
eth1: authentication frame received from 00:01:f4:75:16:74, but not in
authenticate state - ignored
eth1: privacy configuration mismatch and mixed-cell disabled - disassociate
ADDRCONF(NETDEV_UP): eth1: link is not ready
---

I really have bo idea what this means... with ipw3945 (ieee80211
based) the same network works just fine.

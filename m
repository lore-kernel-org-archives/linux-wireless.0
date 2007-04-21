Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from amsfep17-int.chello.nl ([213.46.243.15]:14139 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030468AbXDUIaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 04:30:39 -0400
Received: from [192.168.4.6] (really [62.163.57.155])
          by amsfep11-int.chello.nl
          (InterMail vM.6.01.04.04 201-2131-118-104-20050224) with ESMTP
          id <20070421082731.LGJ25741.amsfep11-int.chello.nl@[192.168.4.6]>
          for <linux-wireless@vger.kernel.org>;
          Sat, 21 Apr 2007 10:27:31 +0200
Subject: mac80211-7.0.4 ieee80211_ptr trouble
From: Dick <dm@chello.nl>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sat, 21 Apr 2007 10:27:32 +0200
Message-Id: <1177144052.9892.8.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm trying to compile compatible mac80211 modules with
linux-2.6.20-gentoo-r6 but I'm missing the ieee80211_ptr in struct
net_device.

/var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c: In functie 'ieee80211_ioctl_get_hw_features':
/var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c:119: fout: 'struct net_device' has no member named 'ieee80211_ptr'
/var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c: In functie 'ieee80211_ioctl_scan':
/var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c:172: fout: 'struct net_device' has no member named 'ieee80211_ptr'

What am I doing wrong, what happened to ieee80211_ptr?

Thanks in advance,
Dick


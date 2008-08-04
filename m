Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:46414 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761356AbYHDTLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 15:11:07 -0400
Received: from cpe0018f85aee2d-cm00140454b5f8.cpe.net.cable.rogers.com ([72.140.151.132] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1KQ5SU-0007rg-Hw
	for linux-wireless@vger.kernel.org; Mon, 04 Aug 2008 15:11:06 -0400
Date: Mon, 4 Aug 2008 15:09:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: one remaining unused CONFIG variable under net/
Message-ID: <alpine.LFD.1.10.0808041508070.11910@localhost.localdomain> (sfid-20080804_211117_795474_92E803F8)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


  this is the single remaining CONFIG variable under the net/
directory that is currently unreferenced.

===== MAC80211_VERBOSE_SPECT_MGMT_DEBUG
net/mac80211/Kconfig:206:config MAC80211_VERBOSE_SPECT_MGMT_DEBUG

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================

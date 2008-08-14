Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:35732 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbYHNKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 06:00:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KTZcg-0001Ok-BH
	for linux-wireless@vger.kernel.org; Thu, 14 Aug 2008 10:00:02 +0000
Received: from htibin536-bam.bfh.ch ([147.87.109.9])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 10:00:02 +0000
Received: from michael.bernhard by htibin536-bam.bfh.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 10:00:02 +0000
To: linux-wireless@vger.kernel.org
From: "Bernhard Michael [bam8]" <michael.bernhard@bfh.ch>
Subject: Re: 2.6.27-rc ... iwl3945 regression?
Date: Thu, 14 Aug 2008 11:58:59 +0200
Message-ID: <g80vl3$p9j$1@ger.gmane.org> (sfid-20080814_120010_374765_11C7DDF5)
References: <200808140208.18969.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <200808140208.18969.david-b@pacbell.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> But with 2.6.27-rc, that's not true.  Left-click shows me two "Wired"
> networks, "Intel Corporation PRO/Wireless 3945ABG Network Connection"
> replacing the list of cells I would expect.  Status of RF switch
> at boot doesn't matter.

You have to select "Wireless extensions sysfs files" 
(WIRELESS_EXT_SYSFS) in the kernel config.

AFIK the Network Manager (in Ubuntu 8.04) uses this entry to determine
whether an interface is wireless or not.

Michael


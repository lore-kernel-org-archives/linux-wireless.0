Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55580 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXJJLD6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 07:03:58 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IfZKp-00019l-SD
	for linux-wireless@vger.kernel.org; Wed, 10 Oct 2007 11:02:39 +0000
Received: from 80.169.182.16 ([80.169.182.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 11:02:39 +0000
Received: from marcus by 80.169.182.16 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 11:02:39 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: rt2500pci 2.0.9 not working
Date: Wed, 10 Oct 2007 12:56:40 +0200
Message-ID: <feibbk$de1$1@sea.gmane.org> (sfid-20071010_120403_687462_921C8576)
References: <fdqhn4$qab$1@sea.gmane.org> <fei4sd$mm0$1@sea.gmane.org> <1192008384.12541.8.camel@johannes.berg> <fei71k$tu7$1@sea.gmane.org> <1192009901.12541.15.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Looking at the code... Ahh, I see. You've selected the B mode instead of
> G and the AP requires G. I think my "[PATCH] mac80211: fix set_channel
> regression" will fix this for you.

No, I still get the same result.

Marcus



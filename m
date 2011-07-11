Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58399 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287Ab1GKILk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 04:11:40 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QgBab-0006Sl-3p
	for linux-wireless@vger.kernel.org; Mon, 11 Jul 2011 10:11:37 +0200
Received: from playroom.cs.hut.fi ([130.233.194.222])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2011 10:11:37 +0200
Received: from swaminathanvasanth.r by playroom.cs.hut.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2011 10:11:37 +0200
To: linux-wireless@vger.kernel.org
From: Swaminathan Vasanth <swaminathanvasanth.r@gmail.com>
Subject: Re: [PATCH 0/4] hostapd: add ACS support
Date: Mon, 11 Jul 2011 08:11:25 +0000 (UTC)
Message-ID: <loom.20110711T100452-391@post.gmane.org> (sfid-20110711_101144_445864_C78E7F9B)
References: <1308801053-2461-1-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <lrodriguez@...> writes:

> Other algorithms for ACS shoudl be easy to plug in, for example,
> spectral scan ;)
> 
> Anyway, to enable and test this thing just set CONFIG_ACS=1
> on your build config and then something like this on your
> hostapd.conf:
> 
> channel=acs_survey
> acs_num_req_surveys=10
> acs_roc_duration_ms=100
> 
> Test results, rants are appreciated.

I am willing to test the hostapd auto channel selection implementation by
integrating it with Openwrt firmware with Netgear WNDR 3700 Router. Currently i
got the patch (acs-all-in-one-v1.patch) and integrating it with the stable
release of hostapd 0.6.10. 

Hope it will be useful for you. 

BR,
Vasanth 
> 
> Luis R. Rodriguez (4):
>   hostapd: split up channel checking into helpers
>   hostapd: add offchannel support
>   hostapd: add survey dump support
>   hostapd: add Automatic Channel Selection (ACS) support



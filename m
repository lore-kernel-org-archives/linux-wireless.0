Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54320 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab0D0Kz3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 06:55:29 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1O6iRr-0004Op-PD
	for linux-wireless@vger.kernel.org; Tue, 27 Apr 2010 12:55:27 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 27 Apr 2010 12:55:27 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 27 Apr 2010 12:55:27 +0200
To: linux-wireless@vger.kernel.org
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [PATCH] ath9k: remove usage of deprecated noise value
Date: Tue, 27 Apr 2010 10:55:19 +0000 (UTC)
Message-ID: <loom.20100427T125258-288@post.gmane.org>
References: <1272312561-22648-1-git-send-email-linville@tuxdriver.com> <4BD682AF.6030206@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benoit PAPILLAULT <benoit.papillault@...> writes:
> Before removing noise reporting and all related code, wouln't it be 
> better to have a replacement API? 

I thought this is what NL80211_CMD_GET_SURVEY is supposed to do...
See
http://osdir.com/ml/linux-wireless/2009-11/msg00977.html


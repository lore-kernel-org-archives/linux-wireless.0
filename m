Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:39450 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab2DTOrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 10:47:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 20 Apr 2012 16:47:04 +0200
From: michael-dev <michael-dev@fami-braun.de>
To: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@lists.ath9k.org>
Subject: [resolved] Re: AR9300 AP/VLAN support
In-Reply-To: <ec6e0b9887c115cea9aa70c14702b4ae@fami-braun.de>
References: <ec6e0b9887c115cea9aa70c14702b4ae@fami-braun.de>
Message-ID: <9e8a9244a07dbc846e8dcd8ea8973295@fami-braun.de> (sfid-20120420_164724_777017_7558F413)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

looks more like a bug in hostapd after enabling some more debug 
configure options, also the kernel is dropping the eapol frame due to 
the target station not being associated.

Regards,
  M. Braun

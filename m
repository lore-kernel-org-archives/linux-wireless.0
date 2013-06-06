Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from soto.provo.novell.com ([137.65.250.214]:55476 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3FFERn convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:3:1>);
	Thu, 6 Jun 2013 00:17:43 -0400
Message-Id: <51B099FE0200009200022E0D@soto.provo.novell.com> (sfid-20130606_061746_887758_9E445931)
Date: Wed, 05 Jun 2013 22:17:34 -0600
From: "Matt Chen" <machen@suse.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Michal Marek" <MMarek@suse.com>, <oneukum@suse.de>,
	<tiwai@suse.de>
Subject: WLAN EAP methods verification.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I would like to ask if there is a policy or way to verify a WLAN driver in kernel such as ath9k, iwlwifi, rt2x00 or rtlwifi and so on ... pass all the EAP method [1] or WPA/WPA2 
encryption ?


[1] http://en.wikipedia.org/wiki/Extensible_Authentication_Protocol

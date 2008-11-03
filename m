Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57117 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751557AbYKCW2K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 17:28:10 -0500
Subject: Re: why differnet wlan drivers need different settings?
From: Alexey Fisher <bug-track@fisher-privat.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1225747524.21347.2.camel@localhost.localdomain>
References: <200810251153.25533.bug-track@fisher-privat.net>
	 <200810251303.35295.rjw@sisk.pl> <20081025135512.GG19057@tuxdriver.com>
	 <200810252245.30279.bug-track@fisher-privat.net>
	 <1225124023.13499.40.camel@localhost.localdomain>
	 <1225747524.21347.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 23:28:06 +0100
Message-Id: <1225751286.8131.9.camel@zwerg> (sfid-20081103_232815_863500_8C248BC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, den 03.11.2008, 16:25 -0500 schrieb Dan Williams:

> Ping; could you submit the patch with the proper signed-off-by
> statement?
> 
> Thanks!
> Dan
Sorry didn't thought it was to me.
i did't had a time to find how to supply patch with git .. i think it
should be some thing with git-diff and git-formate-mail.. is it?
Can you please write how to do it correctly, i really do not haw time to
find it out now. 

signed-off-by: Alexey Fisher

diff --git a/drivers/net/wireless/ipw2200.c
b/drivers/net/wireless/ipw2200.c
index dcce354..d26beed 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -7581,8 +7581,7 @@ static int ipw_associate(void *data)
 	}
 
 	if (!(priv->config & CFG_ASSOCIATE) &&
-	    !(priv->config & (CFG_STATIC_ESSID |
-			      CFG_STATIC_CHANNEL | CFG_STATIC_BSSID))) {
+	    !(priv->config & (CFG_STATIC_ESSID | CFG_STATIC_BSSID))) {
 		IPW_DEBUG_ASSOC("Not attempting association (associate=0)\n");
 		return 0;
 	}




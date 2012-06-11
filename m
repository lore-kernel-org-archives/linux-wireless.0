Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ivanich.tenet.odessa.ua ([85.238.100.22]:47985 "EHLO
	ivanich.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2FKSIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 14:08:48 -0400
From: Ivan Ivanich <ivanich@ivanich.org.ua>
To: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: RTL8192CE randomly drops signal when used as access point
Date: Mon, 11 Jun 2012 20:41:40 +0300
Message-ID: <11551281.OmQPcF3BmP@ivanich.org.ua> (sfid-20120611_200851_806647_19BC0363)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could you please look again in 
https://bugzilla.redhat.com/show_bug.cgi?id=797709 , all commits/patches 
mentioned in this bugreport unfortunaly doesn't fix the problem and connection 
still hangs, I've tried reload all wifi related modules but wifi signal didn't 
appears, it works only after reboot only a few hours and then again randomly 
hangs. Also tried drivers from realtek site but result the same. 

Ivan

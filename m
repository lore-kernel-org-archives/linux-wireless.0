Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:48444 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762870AbXFHSwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 14:52:46 -0400
Received: from poczta.o2.pl (mx12.go2.pl [193.17.41.142])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id E15D62307F2
	for <linux-wireless@vger.kernel.org>; Fri,  8 Jun 2007 20:51:54 +0200 (CEST)
Received: from poczta.o2.pl (mx12 [127.0.0.1])
	by poczta.o2.pl (Postfix) with ESMTP id D58AF3E806F
	for <linux-wireless@vger.kernel.org>; Fri,  8 Jun 2007 20:50:49 +0200 (CEST)
Received: from Z-98C0293EFA704 (87-205-45-25.adsl.inetia.pl [87.205.45.25])
	by poczta.o2.pl (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Fri,  8 Jun 2007 20:50:49 +0200 (CEST)
Date: Fri, 8 Jun 2007 20:50:31 +0200
From: zergavis <zergavis@o2.pl>
Reply-To: zergavis <zergavis@o2.pl>
Message-ID: <1279688715.20070608205031@o2.pl>
To: linux-wireless@vger.kernel.org
Subject: mac80211 "wme.c:398" error
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

My name is Pawel Bieniek, and I'm new on this list.

Today I was trying to compile mac80211 into my kernel (2.6.21.4) on
archlinux. I need it to run intel 4965AGN on my toshiba satelite A200
notebook.

Unfortunately, it returns an error during compilation:

net/mac80211/wme.c: In function 'wme_qdiscop_destroy':
net/mac80211/wme.c:358: warning: implicit declaration of function 
'tcf_destroy_chain'
net/mac80211/wme.c: In function 'wme_qdiscop_init':
net/mac80211/wme.c:398: warning: dereferencing 'void *' pointer
net/mac80211/wme.c:398: error: request for member 'wiphy' in something not 
a structure or union

Could someone help me handle with this?

Regards,
Pawel


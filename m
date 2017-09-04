Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.newmedia-net.de ([185.84.6.166]:43650 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753566AbdIDOZD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 10:25:03 -0400
To: linux-wireless@vger.kernel.org
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: current wireless-next mac80211 test result
Message-ID: <e7efa293-0356-559d-fb19-78507ea21606@dd-wrt.com> (sfid-20170904_162507_298293_4BB9F6AF)
Date: Mon, 4 Sep 2017 16:08:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tested yesterday the current wireless-next tree with backports and 
openwrt and also dd-wrt and ath10k

after a few minutes the load was up to 50.0 . after downgrading just 
mac80211 to the january version but still using latest ath10k

with some small mods to fit to the api, everything was back to normal 
again. since some ioctls i used for a special kernel driver deadlocked 
at the same time

where the load was getting high, it seems for me like a deadlock problem 
in mac802.11 using some big fat kernel lock. didnt had much time for 
more research. just wanted to give that information to this group

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

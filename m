Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33608 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZLJQrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 11:47:12 -0500
Received: by bwz27 with SMTP id 27so6262399bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2009 08:47:17 -0800 (PST)
From: Holger Schurig <holgerschurig@googlemail.com>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: Switching channel in IBSS network doesn't work in ath9k
Date: Thu, 10 Dec 2009 18:46:40 +0100
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
References: <500577.32161.qm@web51405.mail.re2.yahoo.com>
In-Reply-To: <500577.32161.qm@web51405.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200912101846.40572.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> P.S.: Is there a way to get an overview of the current interface
>  configuration with iw? What is the equivalent of "iwconfig wlan0"?

There's none. Currently, iw iw written almost like a direct representation 
of cfg80211 commands. For things like "iw link", the code has added a bit of 
magic, so that this actually sends two cfg80211 command. But in general, 
it's a 1:1 relation.

So, you'd need to write some "give me greatest amount of info" command newly 
for iw.

-- 
http://www.holgerschurig.de

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f168.google.com ([209.85.219.168]:44502 "EHLO
	mail-ew0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbZCQW0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 18:26:21 -0400
Received: by ewy12 with SMTP id 12so230776ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 15:26:18 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Mar 2009 18:26:18 -0400
Message-ID: <86201b3f0903171526l62258146q3f9fb15166813484@mail.gmail.com> (sfid-20090317_232642_234193_B4888F7A)
Subject: Support for country information
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm writing a wireless driver that will use mac80211.  I am developing
with a 2.6.28-00106 version kernel.  I took a look at the files in
net/mac80211 and I don't see any code that looks at the country
element in beacons and probe responses.  Am I missing something?  Does
mac80211 handle country specific settings and regulatory domains?  If
so, could you please tell me where I can find that code?  I need to
figure out how to support 802.11j.  If country specific information is
not supported at present, do you have a plan for when it will be?

Also, does mac80211 handle 802.11a action messages like the ones to
change channels?

Thanks for you help.

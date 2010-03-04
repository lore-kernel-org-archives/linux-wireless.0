Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.jacobs-university.de ([212.201.44.23]:55187 "EHLO
	hermes.jacobs-university.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845Ab0CEAfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 19:35:34 -0500
Received: from localhost (demetrius4.jacobs-university.de [212.201.44.49])
	by hermes.jacobs-university.de (Postfix) with ESMTP id 2E881C000D
	for <linux-wireless@vger.kernel.org>; Fri,  5 Mar 2010 01:25:42 +0100 (CET)
Received: from hermes.jacobs-university.de ([212.201.44.23])
	by localhost (demetrius4.jacobs-university.de [212.201.44.32]) (amavisd-new, port 10024)
	with ESMTP id GDjPJAMbcXit for <linux-wireless@vger.kernel.org>;
	Fri,  5 Mar 2010 01:25:41 +0100 (CET)
Received: from exchange.jacobs-university.de (SHUBCAS02.jacobs.jacobs-university.de [10.70.0.123])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by hermes.jacobs-university.de (Postfix) with ESMTPS id 7E5ACC0002
	for <linux-wireless@vger.kernel.org>; Fri,  5 Mar 2010 01:25:41 +0100 (CET)
Message-ID: <4B9024DE.308@jacobs-university.de>
Date: Thu, 4 Mar 2010 22:23:42 +0100
From: Darko Makreshanski <d.makreshanski@jacobs-university.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Mesh support for gumstix's wireless (Marvell 88W8385 wireless chip
 with CF interface)
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I would like to ask a quick question to anybody that is familiar in this 
area.

I would like to know if I can use a mesh networking with the wifi chip 
used for gumstix (88W8385 with most probably CF interface).

I am aware that the XO (OLPC) laptops have a Marvell 88W8388 chip (with 
USB interface) which is used with the libertas_tf driver, has support 
for mesh networking through open80211s.

Couple of things that I have found out:

1. on the linux-wireless website it is stated that libertas_tf driver 
supports only 88W8388 driver and libertas driver supports both 88W8385 
and 88W8388
2. also at linux-wireless it is also stated that both libertas_tf and 
libertas are supported for mesh networking
3. on the open80211s website at the drivers page only the libertas_tf is 
present.
4. i have read somewhere that the libertas driver is not based on the 
mac80211 layer, so it cannot work with open80211s.

What I would like to ask:

1. will mesh networking work with the 88W8385 chip on gumstix with the 
libertas driver?
2. if yes, is it open80211s or something else?
3. if not, is it possible to make the libertas_tf driver work with this 
chip?

Best regards,
Darko

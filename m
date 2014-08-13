Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:48965 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMKCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 06:02:55 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 0C05C2C08193
	for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2014 11:52:32 +0200 (CEST)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NoP2IC0CJwop for <linux-wireless@vger.kernel.org>;
	Wed, 13 Aug 2014 11:52:31 +0200 (CEST)
Received: from [192.168.1.8] (net-37-116-90-224.cust.vodafonedsl.it [37.116.90.224])
	by aurora.create-net.org (Postfix) with ESMTPSA id 76B652C0818F
	for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2014 11:52:31 +0200 (CEST)
Message-ID: <53EB355E.6090508@create-net.org> (sfid-20140813_120259_727542_9924FF23)
Date: Wed, 13 Aug 2014 11:52:30 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: About the TSFT field
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm planning to use the TSFT field present in the radiotap
header in order to reconstruct a timeline of packet
reception at different AP.

As far as I've understood the TSFT is generated from the MAC,
however I do not know to which instant the TSFT is relative,
the first bit of the MAC payload, the beginning of the PLCP,
etc.

Also I do not know from which reference the TSFT is generated,
I mean two AP synchronized using NTP will have consistent
TSFT, which kind of error should I expect?

R.

-- 
--------------------------------------------------------
Roberto Riggio, Ph.D.
CREATE-NET
Future Networks (FuN)
Senior Researcher
Via alla Cascata 56/D - 38123 Povo Trento (Italy)
e-mail: roberto.riggio@create-net.org
Tel: (+39) 0461 408400 - interno/extension 1708
Fax: (+39) 0461 421157
http://www.create-net.org/~rriggio/
--------------------------------------------------------

The information transmitted is intended only for the person or entity to
which it is addressed and may contain confidential and/or privileged
material. Any review, retransmission, dissemination or other use of, or
taking of any action in reliance upon, this information by persons or
entities other than the intended recipient is prohibited according to
the Italian Law 196/2003 of the Legislature. If you received this in
error, please contact the sender and delete the material from any
computer.

Le informazioni contenute in questo messaggio di posta elettronica e nei
file allegati sono da considerarsi strettamente riservate. Il loro
utilizzo e' consentito esclusivamente al destinatario del messaggio, per
le finalita' indicate nel messaggio stesso. Qualora riceveste questo
messaggio senza esserne il destinatario, Vi preghiamo cortesemente di
darcene notizia via e-mail e di procedere alla cancellazione del
messaggio stesso dal Vostro sistema. Trattenere il messaggio stesso,
divulgarlo anche in parte, distribuirlo ad altri soggetti, copiarlo,
od utilizzarlo per finalita' diverse, costituisce comportamento
contrario ai principi dettati dal D. Lgs. 196/2003.

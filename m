Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55054 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYDAWLu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 18:11:50 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jgohn-0005W6-OB
	for linux-wireless@vger.kernel.org; Tue, 01 Apr 2008 22:11:47 +0000
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 22:11:47 +0000
Received: from tobutaz+kernel by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 22:11:47 +0000
To: linux-wireless@vger.kernel.org
From: TK <tobutaz+kernel@gmail.com>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
Date: Tue, 1 Apr 2008 22:11:39 +0000 (UTC)
Message-ID: <fsubur$cik$1@ger.gmane.org> (sfid-20080401_231154_005815_9F3EA1BD)
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
	<200804010010.15705.IvDoorn@gmail.com>
	<53141.201.36.161.238.1207002489.squirrel@mamao.cetuc.puc-rio.br>
	<a32f33a40804010151v6cd1c6d6w9c4e6cc03b7db01d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 01 Apr 2008 10:51:36 +0200, Ivo Van Doorn said:

> Hi,
> 
>> The configuration (kernel 2.6.23.1) seems OK (mac80211  132112  4
>>  rc80211_simple,rt2500pci,rt2x00pci,rt2x00lib),
> 
> I still have the same question, what version? kernel 2.6.23 does not
> contain rt2x00, so what version are you using?

modinfo rt2500pci is a good command to type.


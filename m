Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:63485 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZIHI1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 04:27:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id A7E4C148005
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2009 10:27:40 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IigAPE9+rART for <linux-wireless@vger.kernel.org>;
	Tue,  8 Sep 2009 10:27:40 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95FA395.dip0.t-ipconnect.de [217.95.163.149])
	by mx51.mymxserver.com (Postfix) with ESMTP id 4FA72148008
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2009 10:27:39 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 287061E004F
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2009 10:27:30 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Possible WEP encryption error with wpa_supplicant -Dnl80211
Date: Tue, 8 Sep 2009 10:27:14 +0200
References: <200909081016.37204.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909081016.37204.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909081027.14299.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> IEEE 802.11
>     Type/Subtype: Data (32)
>     Frame Control: 0x0108 (Normal)
>         Version: 0
>         Type: Data frame (2)
>         Subtype: 0
>         Flags: 0x1
>             DS status: Frame from STA to DS via an AP (To DS: 1 From DS: 0) (0x01)
>             .... .0.. = More Fragments: This is the last fragment
>             .... 0... = Retry: Frame is not being retransmitted
>             ...0 .... = PWR MGT: STA will stay up
>             ..0. .... = More Data: No data buffered
>             .0.. .... = Protected flag: Data is not protected
>             0... .... = Order flag: Not strictly ordered
>     Duration: 213
>     BSS Id: 00:1b:53:11:dc:40 (00:1b:53:11:dc:40)
>     Source address: Proxim_a0:6d:40 (00:20:a6:a0:6d:40)
>     Destination address: Broadcast (ff:ff:ff:ff:ff:ff)
>     Fragment number: 0
>     Sequence number: 120

When I run wpa_supplicant with -D wext, I see this additional
field while monitoring:

    WEP parameters
        Initialization Vector: 0x222e52
        Key Index: 0
        WEP ICV: 0x9dc1791b (not verified)

-- 
http://www.holgerschurig.de

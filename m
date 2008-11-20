Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47504 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbYKTNgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 08:36:21 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1L39hj-0001kF-HX
	for linux-wireless@vger.kernel.org; Thu, 20 Nov 2008 13:36:19 +0000
Received: from htibin536-bam.bfh.ch ([147.87.109.9])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 13:36:19 +0000
Received: from michael.bernhard by htibin536-bam.bfh.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 13:36:19 +0000
To: linux-wireless@vger.kernel.org
From: Michael Bernhard <michael.bernhard@bfh.ch>
Subject: Witap: Statusbericht 20.11.2008
Date: Thu, 20 Nov 2008 14:35:53 +0100
Message-ID: <gg3p4a$c15$1@ger.gmane.org> (sfid-20081120_143625_915850_F1247F99)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo Rolf

Ich bin bereits ein wenig sp=E4t, doch ich wills lernen :-)

TODO's f=FCr CAPWAP library
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

- Implementation des Discovery Thread beenden
- Service Thread implementieren
- CAPWAP state machine implementieren und in Service Thread integrieren
- DTLS API wie es in CAPWAP beschrieben ist implementieren
- Retransmition und Fragmentation implementieren
- MTU-Discovery (optional)
- Vorhandene Lookup-table generisch machen
- Testen, testen, testen

Arbeiten f=FCr heute
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

1. Vorhandene Lookup-table generisch machen
2. Implementation des Discovery Thread beenden
3. Arbeiten an CAPWAP state machine beginnen

Gruss
Michael

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

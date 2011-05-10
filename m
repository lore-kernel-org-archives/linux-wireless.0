Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53134 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1EJG5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 02:57:12 -0400
Received: by bwz15 with SMTP id 15so4581360bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 23:57:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19912.57383.634547.405469@gargle.gargle.HOWL>
References: <BANLkTinoAmna3mtMWY2Ai82wbGu-T9FzMQ@mail.gmail.com>
	<BANLkTi=Z=i9_WoXX=YbQtF-8imKizRPM+w@mail.gmail.com>
	<BANLkTim_uY0Di13RDHZxOpVQZaDfG3hc8A@mail.gmail.com>
	<19903.49991.848934.183819@gargle.gargle.HOWL>
	<BANLkTi=1E-Ma=N0D-gP_baSjMOvmfM-2KQ@mail.gmail.com>
	<BANLkTi=wXtCNY7TUUpfYpHux8piL09+RuQ@mail.gmail.com>
	<BANLkTiknq4jDQY2-z53QXoyHUb4b4=Oojw@mail.gmail.com>
	<BANLkTi=tZDXs=ja+YKXFVyP3FeuxmWLtuA@mail.gmail.com>
	<19908.11423.898062.510184@gargle.gargle.HOWL>
	<BANLkTin6qOChJQSmjoByS9C2_toFzHNq=A@mail.gmail.com>
	<BANLkTi=X+_cQP7RJh9Y4fPQhbJbgfNK6pQ@mail.gmail.com>
	<BANLkTinvVGrVdmku3G6hEmbv+9+nOwnZPA@mail.gmail.com>
	<19912.44045.774181.844464@gargle.gargle.HOWL>
	<19912.55320.817869.173186@gargle.gargle.HOWL>
	<19912.55857.505921.694732@gargle.gargle.HOWL>
	<BANLkTi=d7BfOBH93bDZMUDV2vhbrVtCgGA@mail.gmail.com>
	<19912.57383.634547.405469@gargle.gargle.HOWL>
Date: Tue, 10 May 2011 02:57:10 -0400
Message-ID: <BANLkTi=BrJPhjA5StJcktkKE7zs3Ob=iOg@mail.gmail.com> (sfid-20110510_085716_082425_3FC3E4A2)
Subject: Re: error initializing AR7010+AR9280 Xbox 802.11n adapter
From: George Nychis <gnychis@gmail.com>
To: Sujith <m.sujith@gmail.com>
Cc: Mark Davis <marked86@gmail.com>, linux-wireless@vger.kernel.org,
	Steven <srumney@sbcglobal.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hm, looks like 0x0411 doesn't match. Can you try this FW ?
>
>

[  393.053564] usb 1-1: new high speed USB device using ehci_hcd and address 5
[  393.525139] usb 1-1: ath9k_htc: Transferred FW: htc_7010.fw, size: 73008
[  394.525196] ath9k_htc 1-1:1.0: ath9k_htc: Target is unresponsive
[  394.525335] Failed to initialize the device
[  394.548205] ath9k_htc: probe of 1-1:1.0 failed with error -22

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60450 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab0GTLu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 07:50:57 -0400
Received: by bwz1 with SMTP id 1so2797981bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 04:50:55 -0700 (PDT)
From: Holger Schurig <holgerschurig@googlemail.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: ath5k Ad Hoc Association
Date: Tue, 20 Jul 2010 13:50:48 +0200
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com> <AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com> <AANLkTimgt_HdXyGneQMOz7wR7Xs7BBrDUCGoxP1qDcYg@mail.gmail.com>
In-Reply-To: <AANLkTimgt_HdXyGneQMOz7wR7Xs7BBrDUCGoxP1qDcYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007201350.48923.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> iw phy phy0 interface add wlan0 type adhoc
> iw wlan0 set channel 36
> iwconfig wlan0 channel 36
> iwconfig wlan0 essid txctest

I can't think of ANY reason why you do that. Use "iw", not "iwconfig". 

All the last three commands should be replaced with one single "iw dev wlan0 
ibss join myibss XXXX", where XXXX is the frequency for channel 36. If in 
doubt what this is, just do "iw list" and you'll see it.

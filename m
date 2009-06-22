Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:52000 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZFVRUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 13:20:40 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1950282ywb.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 10:20:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0906200232j531d5804g283a3d93401652a@mail.gmail.com>
References: <4A3B5B11.7060103@bitnet.be>
	 <45e8e6c40906191000i2e74e06btee7313c5c30bc6a2@mail.gmail.com>
	 <4A3C3423.2060007@bitnet.be>
	 <40f31dec0906200232j531d5804g283a3d93401652a@mail.gmail.com>
Date: Mon, 22 Jun 2009 12:59:40 -0400
Message-ID: <5ce4c42d0906220959g6435cd8cg1db12487730c4729@mail.gmail.com>
Subject: Re: current status of 802.11s mesh in ath5k ?
From: Stephane Davy <davystephane@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Hans Maes <Hans@bitnet.be>, Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am using and testing the Open 80211s project with the ath5k driver.
I have an atheros AR2413 chipset and an atheros AR5212/AR5213 chipset.

I installed my mesh network using this command lines on both devices:
# iw phy phy0 interface add mesh0 type mp mesh_id mesh
# ifconfig mesh0 192.168.1.1 (192.168.1.2 on the other device)
# iw dev mesh0 scan

The mesh network is unstable. I always get this warning messages:
ath5k phy0: unsupported jumbo

When I check on wireshark, it's look like some messages are lost on
the radio media.

What can I do to solve this problems ? And get my mesh network stable ?

Thanks,
Stephane.

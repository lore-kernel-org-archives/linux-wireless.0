Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51873 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab0GTMFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 08:05:24 -0400
Received: by vws14 with SMTP id 14so163272vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 05:05:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201007201350.48923.holgerschurig@gmail.com>
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com>
	<AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com>
	<AANLkTimgt_HdXyGneQMOz7wR7Xs7BBrDUCGoxP1qDcYg@mail.gmail.com>
	<201007201350.48923.holgerschurig@gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Tue, 20 Jul 2010 22:05:02 +1000
Message-ID: <AANLkTinytWGuChBFYuU5V6EPVKCJPMPlt6PTD2_jLAmX@mail.gmail.com>
Subject: Re: ath5k Ad Hoc Association
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I understand that it's not the way I'm supposed to do it. What I'm
saying is that it's not working, whereas the other way is! :(

I will play around some more with it tomorrow. It's still baffling as
to why the driver is not beaconing until there is another node tho...

--
Jonathan Guerin



On Tue, Jul 20, 2010 at 9:50 PM, Holger Schurig
<holgerschurig@googlemail.com> wrote:
>> iw phy phy0 interface add wlan0 type adhoc
>> iw wlan0 set channel 36
>> iwconfig wlan0 channel 36
>> iwconfig wlan0 essid txctest
>
> I can't think of ANY reason why you do that. Use "iw", not "iwconfig".
>
> All the last three commands should be replaced with one single "iw dev wlan0
> ibss join myibss XXXX", where XXXX is the frequency for channel 36. If in
> doubt what this is, just do "iw list" and you'll see it.
>

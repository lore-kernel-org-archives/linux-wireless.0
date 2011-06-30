Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37075 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1F3Apn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 20:45:43 -0400
Received: by ywe9 with SMTP id 9so688501ywe.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 17:45:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU158-w3443764A60DE4B497231DB87570@phx.gbl>
References: <BLU158-w3443764A60DE4B497231DB87570@phx.gbl>
Date: Thu, 30 Jun 2011 01:45:41 +0100
Message-ID: <BANLkTi=EUnXpdCYb-Y7=g9seJCkbCTQ5tQ@mail.gmail.com> (sfid-20110630_024546_651620_99849E47)
Subject: Re: [ath9k-devel] STBC functionality details request
From: Fred Matthews <fredmm@hotmail.co.uk>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Please may someone kindly reply to my query regarding STBC (below),
Thanks!


On Mon, Jun 27, 2011 at 12:18 PM, Fred Matthews <fredmm@hotmail.co.uk> wrote:
>
> Hi,
> I am using STBC (Space Time Block Coding) 1 stream NICs like the AR9280.I would be very grateful someone can kindly advise on how exactly STBC(transmits multiple copies of a data across each of the antennas) works in ath9k.
> I ask this because when I enable STBC 1-stream, the driver seems to uses Space division multiplexing (can this be disabled/enabled?), since the rate is over 150Mbps.
> When is STBC activated ?, ...Does Minstrel/ath9k rate adaptation mechanism find first check if Spatial multiplexing is better, if not uses STBC ?
> Thank you for your time
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>

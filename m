Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:59927 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab3BUXtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 18:49:36 -0500
Received: by mail-vb0-f43.google.com with SMTP id fs19so62238vbb.16
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2013 15:49:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5126A993.8060408@candelatech.com>
References: <511935F2.8080103@candelatech.com>
	<20761.34987.125000.908722@gargle.gargle.HOWL>
	<511BC243.8010409@candelatech.com>
	<20770.57339.20017.225929@gargle.gargle.HOWL>
	<51255360.6060603@candelatech.com>
	<51257304.10109@candelatech.com>
	<20773.31380.740958.31338@gargle.gargle.HOWL>
	<5125B39F.3010200@candelatech.com>
	<51265AC3.5030304@candelatech.com>
	<5126A993.8060408@candelatech.com>
Date: Thu, 21 Feb 2013 15:49:33 -0800
Message-ID: <CAJ-Vmo=FC=jdJ9VyZtZy_nbdGhCCfJ9dhS3993fwneGhFjoBJg@mail.gmail.com> (sfid-20130222_004940_553191_753FE471)
Subject: Re: 3.7.6+: ath9k: tx logic locks up after taking attenuation very high.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. so the current code correctly soft fails all of those frames and
puts them back onto the relevant software queues, right?


Adrian

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:62477 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876AbZAPPdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 10:33:15 -0500
Received: by yx-out-2324.google.com with SMTP id 8so615758yxb.67
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 07:33:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200901151734.46144.gbburkhardt@verizon.net>
References: <200901140003.31693.gbburkhardt@verizon.net>
	 <40f31dec0901140530n7ff2029em67687dcd1eab590f@mail.gmail.com>
	 <200901151734.46144.gbburkhardt@verizon.net>
Date: Fri, 16 Jan 2009 10:33:13 -0500
Message-ID: <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com> (sfid-20090116_163320_115367_5CAE1768)
Subject: Re: poor performance with ath5k; reverting to ath_pci
From: Bob Copeland <me@bobcopeland.com>
To: Glenn Burkhardt <gbburkhardt@verizon.net>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 15, 2009 at 5:34 PM, Glenn Burkhardt
<gbburkhardt@verizon.net> wrote:
> ath5k_pci 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> ath5k_pci 0000:00:07.0: registered as 'phy0'
> phy0: Selected rate control algorithm 'pid'

Can you change the rate control algorithm to minstrel and retry?

-- 
Bob Copeland %% www.bobcopeland.com

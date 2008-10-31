Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:42378 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaSsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 14:48:12 -0400
Date: Fri, 31 Oct 2008 16:48:59 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	willy@linux.intel.com, lrodriguez@atheros.com
Subject: Re: ath5k gets lost with eeepc-laptop removal
Message-ID: <20081031164859.7808de23@doriath.conectiva> (sfid-20081031_194818_381694_CE7F27FA)
In-Reply-To: <20081031164351.3e4a9d4e@doriath.conectiva>
References: <20081031110502.18e33eba@doriath.conectiva>
	<40f31dec0810310926p6edd0af5o24d7616eb54c6d0@mail.gmail.com>
	<20081031151901.2d68c32d@doriath.conectiva>
	<40f31dec0810311133v65001e59h28cf6946ac3f14e7@mail.gmail.com>
	<20081031164351.3e4a9d4e@doriath.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Fri, 31 Oct 2008 16:43:51 -0200
"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> escreveu:

| Em Fri, 31 Oct 2008 20:33:43 +0200
| "Nick Kossifidis" <mickflemm@gmail.com> escreveu:
| 
| | 2008/10/31 Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>:
| | >
| | >  No, it doesn't. It says:
| | >
| | > """
| | > MAC revision 0xffff is not supported!
| | > """
| | >
| | >  And I have realized that I get a flood of 'failed to wakeup'
| | > and 'can't reset the hardware' error messages, just some seconds
| | > after the eeepc-laptop module removal.
| | >
| | 
| | Well it seems that during module removal, card gets no power at all.
| | I don't see any reason for this behaviour. Do you have pci-e hotplug enabled ?
| 
|  Well, the pciehp module is not loaded and the eeepc's function keys
| don't work anyway (this is the original problem I was looking at).

 Hmm. You think this could be related, Matthew?

 Actually 'they don't work' is not helpful, I have been looking at
the wireless one (fn2) which doesn't even turn the led off but the
driver seems to receive the event.

-- 
Luiz Fernando N. Capitulino

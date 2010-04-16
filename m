Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:23683 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0DPGoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:44:39 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Survey mode volunteers
Date: Fri, 16 Apr 2010 08:45:01 +0200
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Anton Puolakka <Anton.Puolakka@7signal.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <0290AB2F0A8E124B9FFC144088A1A95609D6029647@EX-MBS04.nbl.local> <201004140911.11459.holgerschurig@gmail.com> <20100414173044.GA2841@tux>
In-Reply-To: <20100414173044.GA2841@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004160845.02027.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Nice, it should be very similar for ath9k

... but please be aware that is is only about 20% of survey. Things that need 
to be addressed are the reporting of some kind of duty-cycle (how much is this 
channel occupied) and logic inside scanning to actually trigger this for 
channels other than the current one.

> BTW, one enhancement which we've
> been meanint to address but haven't had the time yet is to split noise
> floor per channel. This can be seen how its done on the legacy HAL with
> the code sprinkled with the ATH_NF_PER_CHAN ifdef.

Nice, knowing the noise-per-channel AND the channel occupation would be quite 
helpful to select the "best" channel.

-- 
http://www.holgerschurig.de

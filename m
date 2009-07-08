Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:16718 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbZGHHsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 03:48:11 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: a question about marvell sd8686's wmm_config_change event
Date: Wed, 8 Jul 2009 09:48:00 +0200
Cc: fengzeheng <zehengfeng@gmail.com>, dcbw@redhat.com
References: <5135d20a0907070928o19322c3waf41a7b59d4b309e@mail.gmail.com>
In-Reply-To: <5135d20a0907070928o19322c3waf41a7b59d4b309e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907080948.00065.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 07 July 2009 18:28:47 fengzeheng wrote:
> hi, dan and all
>      My wireless card sd8686 reports that wmm_config_change
> about every 2 seconds though wmm's setting in AP's beacons
> don't change. seems that driver receive
> MACREG_INT_CODE_WMM_STATUS_CHANGE event from firmware every 2
> seconds. And according

Hmm, if the firmware sends you a 
MACREG_INT_CODE_WMM_STATUS_CHANGE but you're sure that the 
beacons don't change, then the firmware seems to be buggy.

Not sure if Marvell got sane and opened up their support for 
no-NDA-holders, but you could try and file a bug there.


And we should look into the libertas driver if we always loose a 
packet whenever we get a MACREG :-)

Greetings, Holger

-- 
http://www.holgerschurig.de

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lunatiki.de ([85.214.70.22]:56073 "EHLO
	h1112006.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756590AbZKURvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 12:51:22 -0500
From: Patrick Grimm <patrick@lunatiki.de>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: Re: iwlagn + Ad-Hoc + 5Ghz
Date: Sat, 21 Nov 2009 18:21:53 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jeremy Moles <jeremy@emperorlinux.com>,
	linux-wireless@vger.kernel.org
References: <1258756647.2714.17.camel@localhost.localdomain> <43e72e890911201526y5b36328ft3a510e546508df66@mail.gmail.com> <4B07A9F8.9050306@free.fr>
In-Reply-To: <4B07A9F8.9050306@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200911211821.53377.patrick@lunatiki.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 21. November 2009 09:51:04 schrieb Benoit PAPILLAULT:
> Hello,
> 
> I got the same problem with Intel 4965 and Intel 5350 since those cards
> are using the same drivers. Like Luis mentionned, "no IBSS" should be
> read as "no beaconing authorized by local regulation". However, I think
> the iwlagn interpretation is a bit broad and such restrictions should be
> done by the CRDA framework instead of the driver itself.
> 
> Here in France, IBSS is authorized on all channels. So I made a small
> patch to enable the EEPROM_CHANNEL_IBSS flag everywhere (in iwl-core.c
> and iwl-dev.h) and it just works.
> 
> Will try to post the patch on Monday.
Hi

I have set iw reg DE and the channel 12 and 13 have also the "no IBSS" Flag.
Fix your Patch this too?

Greetings
                       Patrick


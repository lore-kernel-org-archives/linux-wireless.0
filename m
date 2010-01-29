Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51401.mail.re2.yahoo.com ([206.190.38.180]:24073 "HELO
	web51401.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753167Ab0A2IIA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 03:08:00 -0500
Message-ID: <49108.64808.qm@web51401.mail.re2.yahoo.com>
Date: Fri, 29 Jan 2010 00:07:59 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: mac80211: Open bug in current wireless-testing
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1264699110.9434.2.camel@jm-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Jouni Malinen <jouni.malinen@atheros.com> wrote:
> 
> You can control the multicast/broadcast rates with basic
> rate set
> configuration (in hostapd.conf). I think the current rate
> control
> algorithms do not support dynamic rate selection for
> multicast/broadcast, so they will end up picking the lowest
> rate from
> the basic rate set. Anyway, if you include only a single
> rate in the
> basic rate set, that rate will be used for
> multicast/broadcast frames.
> 
> - Jouni

This does not help me. I'm in an IBSS network. 

And no, how would a RC algorithm dynamically select a broadcast rate. 
Broadcast frames are not acknowledged, so there is no feedback that could 
be used to optimize throughput.

Regards
  Joerg

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48349 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2B0PiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:38:09 -0500
Received: by daed14 with SMTP id d14so1218094dae.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 07:38:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330343374.3483.46.camel@jlt3.sipsolutions.net>
References: <1330343374.3483.46.camel@jlt3.sipsolutions.net>
Date: Mon, 27 Feb 2012 16:38:09 +0100
Message-ID: <CAGXE3d_SNsrA-KLuPVe_TWnbaVGK3ABr_4TWbtJWU568=BgWbw@mail.gmail.com> (sfid-20120227_163816_966238_E3C207E1)
Subject: Re: mac80211 queue handling in multi-channel
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 12:49 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Then of course, the driver needs to tell mac80211 about queue mapping.
> For this, there's one global queue:
>  * off-channel TX queue
> Additionally, there are per-interface queues:
>  * 4 per AC
>  * CAB for this interface

Ralink devices have only the 4 hw queues and no CAB queue. So, would
each interface point to the same hw queue or would the driver have to do
some sort of translation?

Also Ralink devices don't have a CAB queue :)

Helmut

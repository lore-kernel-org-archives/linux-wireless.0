Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f183.google.com ([209.85.223.183]:65426 "EHLO
	mail-iw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab0BGT5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 14:57:20 -0500
Received: by iwn13 with SMTP id 13so4111085iwn.25
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 11:57:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265446793.4041.2.camel@johannes.local>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
	 <20100205165726.GA1496@holoscopio.com>
	 <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
	 <1265446793.4041.2.camel@johannes.local>
Date: Sun, 7 Feb 2010 11:51:03 -0800
Message-ID: <c1545bb51002071151wb2cefa3mb03501e0d6b3fb4b@mail.gmail.com>
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh mode
From: Andrey Yurovsky <andrey@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 6, 2010 at 12:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I do wonder though, the commit (155cc9e4b1d60161ee53) I referenced was
> yours, and now you're asking the same question as I am -- "why even
> allow adding stations?"

It was supported for automated testing and experimentation (you could
then force certain topologies).  I can't think of any other reason to
do it.  I suppose that the same thing goes for mpaths and the mesh
portal tables.

  -Andrey

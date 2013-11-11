Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:40711 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3KKSde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 13:33:34 -0500
Received: by mail-la0-f48.google.com with SMTP id n7so3206285lam.7
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 10:33:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384193641-25813-1-git-send-email-egrumbach@gmail.com>
References: <1384193641-25813-1-git-send-email-egrumbach@gmail.com>
Date: Mon, 11 Nov 2013 20:33:33 +0200
Message-ID: <CANUX_P3_ekVGAukog6BXPG5wOh9T3n_vDDh++Gd6-wDR9hpBdQ@mail.gmail.com> (sfid-20131111_193340_578208_FAF34358)
Subject: Re: [PATCH 1/2] mac80211: enable easier manipulation of VHT
 beamforming caps
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Martin Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 11, 2013 at 8:14 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> From: Eyal Shapira <eyal@wizery.com>
>
> Introduce shift and mask defines for beamformee STS cap and number
> of sounding dimensions cap as these can take any 3 bit value.
> While at it also cleanup an unrequired parenthesis.
>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

I forgot to say that I need that in 3.13...

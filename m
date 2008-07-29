Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bromo.msbb.uc.edu ([129.137.3.146]:58702 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753312AbYG2Xsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 19:48:40 -0400
Date: Tue, 29 Jul 2008 19:48:37 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: AP association timeout bugzilla PR?
Message-ID: <20080729234837.GA1920@bromo.msbb.uc.edu> (sfid-20080730_014844_185013_3854D4DF)
References: <20080728172722.GA26893@bromo.msbb.uc.edu> <1217266609.15381.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217266609.15381.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,
    Could you extend your partial fix for skb-cb use
to include patches for the new ath9k driver? I can use
the ath5k changes for a template for what to do for
the lines in drivers/net/wireless/ath9k/xmit.c with
IEEE80211_TX_CTL_DO_NOT_ENCRYPT but I don't how to change
the line with IEEE80211_TX_CTL_EAPOL_FRAME in that file.
Thanks in advance.
                       Jack

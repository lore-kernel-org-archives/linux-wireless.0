Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:47341 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab3BOMlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:41:17 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so1546009bku.27
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 04:41:16 -0800 (PST)
In-Reply-To: <1360930499.15040.7.camel@jlt4.sipsolutions.net>
References: <1360928446-543-1-git-send-email-marco@cozybit.com>	
 (sfid-20130215_124056_325990_55BC105E)
 <1360930499.15040.7.camel@jlt4.sipsolutions.net>
From: marco@cozybit.com
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
To: Johannes Berg <johannes@sipsolutions.net>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=utf-8
Date: Fri, 15 Feb 2013 12:40:58 +0000
Message-ID: <3fance.mi9hwg.2rw1te-qmf@mx.google.com> (sfid-20130215_134124_536269_DFC341C0)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please check again. The comment is split in two and placed on the respective new positions.

Johannes Berg schrieb am 15.02.13 13:14:
On Fri, 2013-02-15 at 12:40 +0100, Marco Porsch wrote:

> -	/* The current tsf is a first approximation for the timestamp
> -	 * for the received beacon.  Further down we try to get a
> -	 * better value from the rx_status->mactime field if
> -	 * available. Also we have to call drv_get_tsf() before
> -	 * entering the rcu-read section.*/

I don't think you should drop this comment; also why not just address
it? There's a timestamp in rx_status that should be the correct one for
ath9k (which is pretty much all this seems to work on anyway :) )

johannes



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab3KMSZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:25:06 -0500
Message-ID: <1384367102.14578.15.camel@jlt4.sipsolutions.net> (sfid-20131113_192513_617981_50F0F7CE)
Subject: Re: [PATCHv2] iw: add support for 5 and 10 MHz channels in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Wed, 13 Nov 2013 19:25:02 +0100
In-Reply-To: <1384277518-12398-1-git-send-email-sw@simonwunderlich.de>
References: <1384277518-12398-1-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-12 at 18:31 +0100, Simon Wunderlich wrote:
> 5/10 MHz requires to send the frequency information as chandef instead
> of the the old channel type, therfore send the chandef next the channel
> type (the latter is still used for old kernels).

Applied.

johannes


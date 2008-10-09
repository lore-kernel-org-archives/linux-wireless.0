Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:29603 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793AbYJIEaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 00:30:11 -0400
To: "Andrey Yurovsky" <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] allow AP interfaces to handle BACK action frames
References: <48ed3fd6.1e068e0a.7847.4d37@mx.google.com>
From: Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <48ed3fd6.1e068e0a.7847.4d37@mx.google.com> (ext Andrey Yurovsky's message of "Wed\, 08 Oct 2008 16\:18\:46 -0700 \(PDT\)")
Date: Thu, 09 Oct 2008 07:29:30 +0300
Message-ID: <87ljwypf11.fsf@nokia.com> (sfid-20081009_063034_177224_935BA3ED)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Yurovsky <andrey@cozybit.com> writes:

> Add AP mode to the allowed interface check in ieee80211_rx_h_action.  This
> function handles BACK action frames such as ADDBA and AP interfaces need to
> receive those.

You forgot mac80211 from the subject, it should be something like
this:

[PATCH] mac80211: allow AP interfaces to handle BACK action frames

-- 
Kalle Valo

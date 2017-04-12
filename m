Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:52909 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754116AbdDLTrp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 15:47:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [RFC 1/3] bpf/wireless: add wifimon program type
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20170412110726.9689-1-johannes@sipsolutions.net>
Date: Wed, 12 Apr 2017 21:47:44 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Message-Id: <74C8B200-1552-497E-853B-33428E8E2FF3@holtmann.org> (sfid-20170412_214749_708494_ED38920D)
References: <20170412110726.9689-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Add a new program type for wifi monitor interfaces. This program
> type can
> * access __sk_buff, but only skb->len
> * call bpf_skb_load_bytes()
> 
> The program type is only enabled when something selects the new
> Kconfig symbol WANT_BPF_WIFIMON, which will be done by mac80211
> in a follow-up patch.

we used to stay away from WIFI naming in the kernel. Any reasoning why this is used instead of WLAN now?

Regards

Marcel

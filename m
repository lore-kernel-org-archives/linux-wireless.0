Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:60988 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbYAJNmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 08:42:10 -0500
Received: by an-out-0708.google.com with SMTP id d31so141210and.103
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 05:42:09 -0800 (PST)
Message-ID: <40f31dec0801100542x7de452d1t8d75a571496c9a62@mail.gmail.com> (sfid-20080110_134220_303892_6FD0D405)
Date: Thu, 10 Jan 2008 15:42:08 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/6] ath5k: code cosmetics
Cc: "Bruno Randolf" <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1199926491.3861.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
	 <1199870169-10476-2-git-send-email-bruno@thinktube.com>
	 <1199926491.3861.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/10, Johannes Berg <johannes@sipsolutions.net>:
>
> > + * @AR5K_TX_QUEUE_UAPSD: Unscheduled Automatic Power Save Delivery queue
>
> Out of curiosity, do you know how that works? Is that queue simply a way
> to avoid the MAC rejecting a packet because the target is in PS?
>
> johannes
>
>

Sort off, this is what i found with a quick look on net80211...
http://madwifi.org/browser/madwifi/trunk/net80211/ieee80211_power.c
http://madwifi.org/browser/madwifi/trunk/net80211/ieee80211_input.c#L563
http://madwifi.org/browser/madwifi/trunk/net80211/ieee80211_output.c#L264

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

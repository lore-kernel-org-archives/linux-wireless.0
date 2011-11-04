Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:51172 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1KDJrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 05:47:25 -0400
Message-ID: <4EB3B4AA.5050409@neratec.com> (sfid-20111104_104729_079239_EE8052AB)
Date: Fri, 04 Nov 2011 10:47:22 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com
Subject: Re: [ath9k-devel] [RFC v2 2/2] ath9k: integrate initial DFS module
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com> <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com> <201111031651.46073.chunkeey@googlemail.com> <4EB2CE96.4060702@neratec.com> <20111104030046.25361.qmail@stuge.se>
In-Reply-To: <20111104030046.25361.qmail@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2011 04:00 AM, Peter Stuge wrote:
> Zefir Kurtisi wrote:
>> Just clarify whether you do not like the CONFIG_ prefix or the fact
>> that it can't be enabled.
> 
> It's IMO always stupid to add dead code. No exceptions for
> $random_authority_which_has_no_jurisdiction_for_billions_of_users.
> 
> 
> //Peter

Hi Peter,

ok, got it.

But I don't call it dead code when its sole purpose is to be tested by developers (i.e. useless for the common user) and can be easily enabled by those. This is only a tiny fraction of the DFS functionality at the lowest layer that need additional support at the upper (mac, hostapd) that is missing so far. Therefore I opted to make it available for devs until all pieces are in (no authority issue, just sanity), but will change it in v3.


Thanks for your feedback
Zefir

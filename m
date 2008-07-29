Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:65339 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYG2P6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 11:58:17 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1708933nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 08:58:15 -0700 (PDT)
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217333247.10489.35.camel@johannes.berg>
References: <1217323927.10489.9.camel@johannes.berg>
	 <1217330604.6379.12.camel@localhost>
	 (sfid-20080729_132329_995714_6D2C9701)  <1217330667.10489.19.camel@johannes.berg>
	 <1217331773.6379.25.camel@localhost>
	 (sfid-20080729_134300_214751_172329C5)  <1217332288.10489.33.camel@johannes.berg>
	 <1217333020.6379.31.camel@localhost>
	 (sfid-20080729_140346_036234_85BD2AA9)  <1217333247.10489.35.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:58:11 +0200
Message-Id: <1217347091.6379.57.camel@localhost> (sfid-20080729_175820_206680_EEE13FDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-29 at 14:07 +0200, Johannes Berg wrote:
> Ok. How is that supposed to work with crypto? Do each two peers
> negotiate a key and forwarding just doesn't change anything so crypto is
> effectively end-to-end?

Actually not, crypto is per link (per hop). We don't have a schedule to
support that but anyway, where do you suggest to save the mesh header in
this case?

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.



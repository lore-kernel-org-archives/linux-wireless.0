Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:52743 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbYBIAMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 19:12:12 -0500
Received: by an-out-0708.google.com with SMTP id d31so948293and.103
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 16:12:11 -0800 (PST)
Subject: Re: [PATCH 01/13] o11s: (rtnetlink) add commands for mesh tables
	manipulation
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202342208.9965.29.camel@johannes.berg>
References: <47a7825b.06538c0a.3bce.5ec1@mx.google.com>
	 (sfid-20080204_212408_298998_A7C8CED4)  <1202342208.9965.29.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 16:13:15 -0800
Message-Id: <1202515995.7025.8.camel@localhost> (sfid-20080209_001222_166972_9FDCC2C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-07 at 00:56 +0100, Johannes Berg wrote:
> On Mon, 2008-02-04 at 10:48 -0800, Luis Carlos Cobo wrote:
> > This patch adds the necessary commands for mesh peer link table and mesh path
> > table manipulation.
> 
> This needs to go via netdev too. Also, why should it be defined as
> "real" netlink rather than within nl80211? It is wireless specific, no?

I'm not sure understand what you mean with "via netdev". About
implementing it nl80211, sounds good, I will think about it and propose
an interface (trying to follow the add/del/get/set).

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.



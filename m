Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2725 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab1CIDvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 22:51:44 -0500
Date: Tue, 8 Mar 2011 22:51:46 -0500
From: me@bobcopeland.com
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, mickflemm@gmail.com
Subject: Re: [PATCH] ath5k: restrict AR5K_TX_QUEUE_ID_DATA_MAX to reflect
	the [0,3] range
Message-ID: <20110309035146.GA16481@hash.localnet>
References: <1299620160-27837-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1299620160-27837-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 08, 2011 at 04:36:00PM -0500, John W. Linville wrote:
> This just matches reality...
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> ..or am I missing something?

No, your change looks right to me. 

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com


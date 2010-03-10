Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2707 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab0CJUrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 15:47:13 -0500
Date: Wed, 10 Mar 2010 15:46:30 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, mickflemm@gmail.com, proski@gnu.org
Subject: Re: [PATCH 1/3] ath5k: remove some dead functions
Message-ID: <20100310204630.GA8801@hash.localnet>
References: <1268237330-30013-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268237330-30013-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 10, 2010 at 11:08:48AM -0500, John W. Linville wrote:
> "ath5k: remove stale function declarations, make some functions static"
> commented-out some unused functions.  This removes them.

Thanks John.  A lot of these have equivalents in the HAL and
could be useful "some day" but as they have been in for such a
long time with no users, and are always there in git if we need
them, you can have my:

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com


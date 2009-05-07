Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f125.google.com ([209.85.221.125]:58546 "EHLO
	mail-qy0-f125.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZEGOEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 10:04:23 -0400
Received: by qyk31 with SMTP id 31so1387190qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 07 May 2009 07:04:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090507085626.GA4562@hash.localnet>
References: <1241626486.30590.13.camel@mj>
	 <b6c5339f0905060936u37f3994cx97cc2344224777a5@mail.gmail.com>
	 <20090506172513.GB30070@tuxdriver.com>
	 <20090507085626.GA4562@hash.localnet>
Date: Thu, 7 May 2009 10:04:19 -0400
Message-ID: <b6c5339f0905070704j43b16e88if70d43429392a2be@mail.gmail.com>
Subject: Re: [ath5k-devel] ath5k: scanning while transmitting causes oops on
	802.11a capable card
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 7, 2009 at 4:56 AM, Bob Copeland <me@bobcopeland.com> wrote:
> Cheesy untested patch (actually, I know it is broken for ath5k_init,
> but you get the idea):

For what it's worth, I have a better version that passes the
channel struct directly to ath5k_reset, after I give it some
testing I'll post with a decent changelog.

-- 
Bob Copeland %% www.bobcopeland.com

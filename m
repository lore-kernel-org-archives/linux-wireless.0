Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:21888 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbXFTMAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 08:00:24 -0400
Received: by ik-out-1112.google.com with SMTP id b32so139697ika
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2007 05:00:22 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] clarify some mac80211 things
Date: Wed, 20 Jun 2007 13:48:33 +0200
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1182333960.3714.54.camel@johannes.berg> <20070620134604.72ecbbc7@griffin.suse.cz> <1182340310.3714.65.camel@johannes.berg>
In-Reply-To: <1182340310.3714.65.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706201348.33834.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 20 June 2007 13:51, Johannes Berg wrote:
> On Wed, 2007-06-20 at 13:46 +0200, Jiri Benc wrote:
> 
> > Maybe it's a time to finally get rid of open and stop callbacks...
> 
> Fine with me, there isn't really much point in them and it'll definitely
> simplify code. Since drivers need to keep track anyway they won't be
> more complicated... bcm43xx for example doesn't use it anyway...

Ehm, I'll fix rt2x00 to stop using those callback functions as soon as possible then. ;)

Ivo

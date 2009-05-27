Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:19884 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761966AbZE0MiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 08:38:19 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2597959ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 05:38:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243287763.29222.9.camel@johannes.local>
References: <1243280050-3755-1-git-send-email-linville@tuxdriver.com>
	 <1243287763.29222.9.camel@johannes.local>
Date: Wed, 27 May 2009 08:38:21 -0400
Message-ID: <b6c5339f0905270538g46032b7cub51545fcaeee2953@mail.gmail.com>
Subject: Re: [PATCH] ath5k: avoid leaking mutex in ath5k_config
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	ath5k-devel@lists.ath5k.org,
	Alan Jenkins <sourcejedi.lkml@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2009 at 5:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-05-25 at 21:34 +0200, John W. Linville wrote:
>> Reported-by: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> ---
>> I lost track of the related bug report -- Johannes, do you recall?
>
> Thanks for fixing -- the report is Alan's (CC'ed) at
> http://article.gmane.org/gmane.linux.kernel.wireless.general/33449

Yes, thanks for catching, looks like it was introduced a few weeks ago
so 2.6.30 is ok.

-- 
Bob Copeland %% www.bobcopeland.com

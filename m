Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:54224 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaG2B1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 21:27:18 -0400
Received: by mail-la0-f46.google.com with SMTP id b8so6113159lan.33
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2014 18:27:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405936933.32255.8.camel@jlt4.sipsolutions.net>
References: <1402471415-22723-1-git-send-email-arik@wizery.com>
 <1403516586.4418.13.camel@jlt4.sipsolutions.net> <20140630222303.GO1390@garbanzo.do-not-panic.com>
 <1405936933.32255.8.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 28 Jul 2014 18:26:56 -0700
Message-ID: <CAB=NE6URWePHjBhKcWE_Jy06YbTsSWF3+xsrw9KcFYZJuv2Gsw@mail.gmail.com> (sfid-20140729_032721_989235_04AB082B)
Subject: Re: [PATCH] regulatory: add NULL to alpha2
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2014 at 3:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This was never intended to be a string, only 2 characters ... so why use
> it with string functions?

Sure makes sense, the report was not clear so indeed, if userspace can
be fixed that's better to enable consistent use.

  Luis

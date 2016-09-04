Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:36853 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbcIDDQV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 23:16:21 -0400
MIME-Version: 1.0
In-Reply-To: <95a6b65277914d88178ed2b15e182455067cca60.1472490319.git.joe@perches.com>
References: <95a6b65277914d88178ed2b15e182455067cca60.1472490319.git.joe@perches.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 4 Sep 2016 13:16:00 +1000
Message-ID: <CAGRGNgXWM8PiqBb5Tk=RQyqbs099J+mLK34Nq15mYrEgBq6FLg@mail.gmail.com> (sfid-20160904_051641_419066_F8A80F92)
Subject: Re: [PATCH] ath10k: Spelling and miscellaneous neatening
To: Joe Perches <joe@perches.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Tue, Aug 30, 2016 at 3:05 AM, Joe Perches <joe@perches.com> wrote:
> Correct some trivial comment typos.
> Remove unnecessary parentheses in a long line.
> Convert a return; before the end of a void function definition to just ;
>
> Signed-off-by: Joe Perches <joe@perches.com>

This all looks correct to me. I wish you'd put the code changes in a
separate patch, however it's all noted in the commit log, so...

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

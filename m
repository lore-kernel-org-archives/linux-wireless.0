Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50297 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752948AbdKWTIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Nov 2017 14:08:51 -0500
Date: Thu, 23 Nov 2017 20:08:49 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Luca Coelho <luca@coelho.fi>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, sedat.dilek@gmail.com,
        linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi 2017-11-19
Message-ID: <20171123190849.GJ729@wotan.suse.de> (sfid-20171123_200855_764344_CE3144C9)
References: <1511175768.4011.261.camel@coelho.fi>
 <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
 <1511259055.4011.268.camel@coelho.fi>
 <871skrdiaf.fsf@kamboji.qca.qualcomm.com>
 <1511264260.4011.274.camel@coelho.fi>
 <20171122194629.GI729@wotan.suse.de>
 <1511383851.4011.319.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511383851.4011.319.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 22, 2017 at 10:50:51PM +0200, Luca Coelho wrote:
> The problem, and the reason why you see it as my having dropped the
> ball, is that the change we needed grew into a massive refactoring of
> the entire firmware loading mechanism, with the addition of driver
> data, lots of advanced options etc.

Yeah I noted that, I don't blame you :)

> You certainly remember that I even reviewed the first patchset, but
> then it all snowballed into discussions that led to literally
> *hundreds* of emails going back and forth and I just didn't have the
> time to follow anymore...

Like I said, I don't blame you. Hopefully for v4.16 things will fly
better.

> But, personally, I'm not in a hurry.  It's a bit annoying to get
> reports repeatedly from the community about those warnings and having
> to explain how things work, but I can live with that.
> 
> I'd be happy to help with anything that doesn't involve following
> hundreds of emails and reviewing massive refactors in code I'm not
> completely familiar with. ;) Let me know.

Let's shoot to get something in for v4.16, for both ath10k and iwlwifi,
but first we need the cleanup to get merged. If you have time some
Reviewed-by's would be nice of the last posted patches.

I'll bounce you copies.

  Luis

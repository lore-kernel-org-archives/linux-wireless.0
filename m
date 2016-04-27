Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36324 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbcD0H3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 03:29:18 -0400
Received: by mail-pa0-f45.google.com with SMTP id bt5so16128611pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2016 00:29:18 -0700 (PDT)
From: Mitchel Humpherys <mitch.special@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Intel WiFi regression on linux-next
References: <87d1pcthr0.fsf@gmail.com> <1461695468.13240.58.camel@coelho.fi>
Date: Wed, 27 Apr 2016 00:29:14 -0700
In-Reply-To: <1461695468.13240.58.camel@coelho.fi> (Luca Coelho's message of
	"Tue, 26 Apr 2016 21:31:08 +0300")
Message-ID: <87vb3333xx.fsf@gmail.com> (sfid-20160427_092922_169650_C5D07E90)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26 2016 at 09:31:08 PM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2016-04-26 at 10:14 -0700, Mitchel Humpherys wrote:
> This was fixed in a patch I sent to Kalle yesterday and he merged
> today:
>
> http://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next
> .git/commit/?id=f0d8f38cd909e072833a06b79939256c4aebe3a0

That did the trick, thanks!

-- 
Mitch

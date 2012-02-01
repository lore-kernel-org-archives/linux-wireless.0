Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63941 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2BAA7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 19:59:36 -0500
Received: by dadp15 with SMTP id p15so422177dad.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 16:59:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F288D79.8040001@gmail.com>
References: <CAO=xpBGCABtjPstHcxcPHL7MGXSa7nQw4ZtwJkfZiTq=DPAE1w@mail.gmail.com>
 <20120201001521.GA1721@tuxdriver.com> <CAO=xpBFwEzTuidOMj02JPjV_mHyiqFpj-CE59Tw6kyqrocRSJA@mail.gmail.com>
 <4F288D79.8040001@gmail.com>
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Wed, 1 Feb 2012 01:59:06 +0100
Message-ID: <CAO=xpBGq-Py149hGXLJGh=5z60D_0RTHELnDWVv8ey2eP-azwA@mail.gmail.com> (sfid-20120201_015938_913068_41A0B05E)
Subject: Re: compat-wireless can't compile under kernel 3.2.0 both 3.3-rc1-2
 and 2012-01-26 - error: missing binary operator before token "("
To: Richard Farina <sidhayn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 1, 2012 at 1:55 AM, Richard Farina <sidhayn@gmail.com> wrote:
> Did you remember to run "make clean" after applying the patch?
>
> -Rick

Hi Rick,

Yes, I think so. But I tried again with make clean to be sure and I
get the same (new) error.

thank you,
alfonso

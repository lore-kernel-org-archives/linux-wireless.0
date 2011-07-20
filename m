Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51668 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1GTQQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 12:16:48 -0400
Received: by fxd18 with SMTP id 18so2001305fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 09:16:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311178071.21004.4.camel@dcbw.foobar.com>
References: <20110717170346.45A739D401C@zog.reactivated.net>
	<1311089696.2647.4.camel@dcbw.foobar.com>
	<CAGq3pz6OP5CNHMvCtxkRKhU-dx097k66d1h0eGJT0Lhs9oM+Cw@mail.gmail.com>
	<1311178071.21004.4.camel@dcbw.foobar.com>
Date: Wed, 20 Jul 2011 17:16:47 +0100
Message-ID: <CAGq3pz4b1uZ2tRNRe_B8yHh1+HGwRdO+CbxJZoyju9-xOf-ZpQ@mail.gmail.com> (sfid-20110720_181651_386823_70C80A84)
Subject: Re: [PATCH 4/4] libertas: reimplement mesh channel selection
From: Daniel Drake <dsd@laptop.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2011 17:07, Dan Williams <dcbw@redhat.com> wrote:
> Storing it is fine; I was just trying to keep the functions that built
> firmware commands from poking priv->xxx stuff.  Hence why there was a
> 'chan' parameter to the function, to push the actual decision about what
> channel to change to up to the thing that actually decided it was
> necessary to change the channel at all.  In this case it's not as
> relevant as other cases, so in the end I don't really care as much.

Ah, now I understand. I'll redo the patch so that it passes it as a
parameter, for consistency with the other functions that you have
designed in this way.

Thanks,
Daniel

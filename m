Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:41965 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbXISSfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 14:35:17 -0400
Received: by wx-out-0506.google.com with SMTP id h31so224936wxd
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2007 11:35:16 -0700 (PDT)
To: David Miller <davem@davemloft.net>
Subject: Re: Please pull 'rt2x00' branch of wireless-2.6
Date: Wed, 19 Sep 2007 20:47:59 +0200
Cc: linville@tuxdriver.com, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20070918213202.GJ4940@tuxdriver.com> <200709192031.19934.IvDoorn@gmail.com> <20070919.112137.48806758.davem@davemloft.net>
In-Reply-To: <20070919.112137.48806758.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709192048.00741.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 19 September 2007, David Miller wrote:
> From: Ivo van Doorn <ivdoorn@gmail.com>
> Date: Wed, 19 Sep 2007 20:31:19 +0200
> 
> > Because I am indeed not really happy with this early merge, but I'll do my
> > best to resolve the last outstanding bugs as soon as possible.
> 
> Relax :-)

:)

> A merge upstream doesn't mean "bug free", it means "significantly
> better than no driver at all" and that is undoubtedly the case
> here.

Well I am happy rt2x00 is being considered good enough for upstream already,
but I have the habbit of wanting things bug-free before pushing it further upstream.

Well most users are happy with current rt2x00 version anyway,
so the remaining issues probably aren't that big anyway. (Except for the 2 panics,
which should be resolved soon anyway) ;)

Ivo

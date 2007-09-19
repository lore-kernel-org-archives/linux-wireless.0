Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:22734 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbXISSZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 14:25:19 -0400
Received: by an-out-0708.google.com with SMTP id d31so42704and
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2007 11:25:18 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Please pull 'rt2x00' branch of wireless-2.6
Date: Wed, 19 Sep 2007 20:31:19 +0200
Cc: davem@davemloft.net, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20070918213202.GJ4940@tuxdriver.com>
In-Reply-To: <20070918213202.GJ4940@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709192031.19934.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> This patch adds the rt2x00 drivers for Ralink wireless hardware.
> This collection of drivers has seen lots of action in Fedora (both
> F7 and rawhide) and many people are using them with good results
> (although some problems do remain).
> 
> Ivo in particular has been very helpful in responding to bug reports
> for these drivers, including bugs reported at kernel.org and in
> distro bugzillas.  I extend my thanks to him for both his past and
> future support of these drivers.  I'm sure he and the rest of the
> rt2x00 team will continue to support the community and their userbase.
> 
> Ivo and his team may feel I am jumping the gun a bit -- they have
> a few more random bugs they wanted to squash before going upstream.
> But since they are bugs, any fixes should still be able to be applied
> in the -rc phase of 2.6.24.  In the meantime, I definitely think it
> would be better to get this code into mainline rather than keeping
> it out of stream.

With 2.6.23 not yet released, I assume we still have a few months to get
rt2x00 shaped up to be really ready for 2.6.24?
Because I am indeed not really happy with this early merge, but I'll do my
best to resolve the last outstanding bugs as soon as possible.

Ivo

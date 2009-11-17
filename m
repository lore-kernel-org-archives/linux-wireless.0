Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:62298 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZKQXNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 18:13:09 -0500
Received: by iwn8 with SMTP id 8so448217iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 15:13:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091117225408.GA20540@jm.kir.nu>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	<4B02DFF4.1060509@roinet.com> <45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com>
	<43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
	<4B03193E.2080304@roinet.com> <43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com>
	<4B031B48.1090105@roinet.com> <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
	<4B032390.3080501@roinet.com> <20091117225408.GA20540@jm.kir.nu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 17 Nov 2009 15:12:54 -0800
Message-ID: <43e72e890911171512k562f9329td56cc741dd1c5151@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
To: David Acker <dacker@roinet.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 2:54 PM, Jouni Malinen <j@w1.fi> wrote:

> Supporting half/quarter width channels sounds reasonable in general. The
> main problem with this one seems to have been in getting someone
> dedicated enough to go through the effort in a way that would cleanly
> extend the regulatory framework in use with cfg80211.

I'll elaborate on this part.

There actually is no requirement to extend the regulatory framework to
get this done. What would need to be done is to extend cfg80211 to get
support for declaring varying channel width support and for a way to
tell cfg80211 which channels we want enabled for these settings -- or
figuring out a generic formula on cfg80211. The regulatory rules would
already be present on cfg80211 -- these would just be used to apply
the channe flags accordingly. I think there was also the theoretical
issues with regulatory bands which might overlap but we haven't yet
faced this issue yet AFAICT.

  Luis

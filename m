Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36185 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab0KRTxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 14:53:38 -0500
Received: by yxf34 with SMTP id 34so2131240yxf.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 11:53:38 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Use sw crypto for GTKs on AP VLAN interfaces
Date: Thu, 18 Nov 2010 20:52:27 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Jouni Malinen <j@w1.fi>
References: <1290094587-5387-1-git-send-email-helmut.schaa@googlemail.com> <1290099699.3801.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290099699.3801.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011182052.27448.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 18 November 2010 schrieb Johannes Berg:
> On Thu, 2010-11-18 at 16:36 +0100, Helmut Schaa wrote:
> > That means, broadcast traffic to and from stations associated to an AP
> > VLAN interface is encrypted and decrypted in software whereas broadcast
> > traffic to and from stations associated to the non-VLAN AP interface is
> > encrypted end decrypted in hardware.
> 
> Minor nit: bcast traffic from stations is never decrypted by these keys
> since stations never send real bcast frames -- just remove the decyrpted
> part and "from stations" part :-)

Ah, yes, you're right. I'll update the comment accordingly ...

Helmut

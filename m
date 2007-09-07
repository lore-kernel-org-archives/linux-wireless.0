Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:50110 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbXIGROn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 13:14:43 -0400
Received: by py-out-1112.google.com with SMTP id u77so1076997pyb
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2007 10:14:43 -0700 (PDT)
Message-ID: <43e72e890709071014w1f37b4acjac3c98c306a965de@mail.gmail.com>
Date: Fri, 7 Sep 2007 13:14:42 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: remove turbo modes
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>, "Jiri Slaby" <jirislaby@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1188485253.3978.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1188485253.3978.22.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/30/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> This patch removes all mention of the atheros turbo modes that
> can't possibly work properly anyway since in some places we don't
> check for them when we should.

Can you elaborate a bit on what places (one would suffice) we should
be checking for them that would prevent failure so that we know where
to correct this later when we want to add support for these modes in
ath5k?

  Luis

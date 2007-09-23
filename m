Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59965
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbXIWQgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2007 12:36:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH] zd1211: Fix crashes with NULL mac addresses (monitor mode)
Date: Sun, 23 Sep 2007 18:35:36 +0200
Cc: Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200709231626.22446.mb@bu3sch.de> <20070923152743.GA23532@deine-taler.de>
In-Reply-To: <20070923152743.GA23532@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709231835.37069.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 23 September 2007, Ulrich Kunitz wrote:
> Daniel is normally reviewing my patches and forwards them to
> linux-wireless. This is our way to ensure quality control before
> the patches hit John's tree.

Yeah, cool. So please get it upstream now. It can't get any worse
with it. The driver currently always crashes.

Also, what's needed to get monitor during operation running?
I guess it's only about removing the artificial restriction
for this in the add_interface callback. Is there something else?

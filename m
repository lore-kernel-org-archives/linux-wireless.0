Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f190.google.com ([209.85.223.190]:58657 "EHLO
	mail-iw0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbZJCTYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2009 15:24:40 -0400
Received: by iwn28 with SMTP id 28so1135886iwn.22
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2009 12:24:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254518013-30223-1-git-send-email-hauke@hauke-m.de>
References: <1254518013-30223-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 3 Oct 2009 12:23:42 -0700
Message-ID: <43e72e890910031223v64b5c9b9w8df447300c818916@mail.gmail.com>
Subject: Re: [PATCH] [compat-2.6] Make it compile with wireless-testing
	master-2009-09-30
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 2, 2009 at 2:13 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> DIV_ROUND_CLOSEST is needed by the b44 driver.
> Most of the rest is needed because of "wext: refactor"
> in wireless-testing.

Applied, thanks!

  Luis

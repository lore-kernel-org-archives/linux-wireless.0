Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48825 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3AKLcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 06:32:08 -0500
Received: by mail-wg0-f52.google.com with SMTP id 12so746840wgh.31
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2013 03:32:05 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Jan 2013 13:32:05 +0200
Message-ID: <CAMvjH0A69ZBCZc5qjm_cUYj3bDzSmneaz1u9CsPcJEm2T0Q1iw@mail.gmail.com> (sfid-20130111_123211_974616_FBFBDA1B)
Subject: Custom commands for cfg80211 based driver (like iwpriv)
From: Eugene <wifi.mailing.list@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How to add custom configuration command for cfg80211 based driver.

For WEXT was private IOCtls (iwpriv).

What the recommended way for nl80211/cfg80211?

Private tool with private API on driver?

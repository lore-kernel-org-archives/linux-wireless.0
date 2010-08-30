Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56868 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab0H3LgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 07:36:20 -0400
Received: by qwh6 with SMTP id 6so4737871qwh.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 04:36:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Date: Mon, 30 Aug 2010 13:36:19 +0200
Message-ID: <AANLkTim1u_yKX4u1N=uTpr3rKXTaz+7b5QErg5w1rQz4@mail.gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 00/27] iwlwifi update for 2.6.37
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/27 Wey-Yi Guy <wey-yi.w.guy@intel.com>:
> We add support for multiple interfaces.
> In order to support multiple interfaces, move
> a lot of data into per-context structures so we can
> use the contexts the device offers.

Any chance to focus on regressions first? :(

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2214

-- 
Rafał

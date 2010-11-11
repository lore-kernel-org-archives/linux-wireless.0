Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55037 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab0KKAOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 19:14:47 -0500
Received: by iwn10 with SMTP id 10so1436455iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 16:14:47 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Nov 2010 16:14:26 -0800
Message-ID: <AANLkTikM78ez4CFbamA29OFRGVZcGoxRZ9s-k6-o=sSD@mail.gmail.com>
Subject: Compat-wireless wl branch updated
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've reset the wl branch for compat-wireless to match today's
wireless-testing.git updates. If you are using wireless-testing.git
instead of linux-next.git you'll have to

git fetch; git reset --hard origin/wl

mcgrof@tux ~/devel/compat-wireless-2.6 (git::wl)$ git describe
compat-wireless-master-2010-11-10-1-g5f54fb0

  Luis

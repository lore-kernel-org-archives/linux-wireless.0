Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62170 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab1LPSzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 13:55:41 -0500
Received: by wgbdr13 with SMTP id dr13so6691600wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Dec 2011 10:55:40 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 16 Dec 2011 19:55:40 +0100
Message-ID: <CACna6rxEyGbxq813UW8RvzaysCd0jCawYZ0G6eN7XiAQOykTig@mail.gmail.com> (sfid-20111216_195544_801037_26C5D39E)
Subject: [RFC] b43: Rearranging functions in phy_n.c
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: b43-dev <b43-dev@lists.infradead.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

The order of functions in phy_n.c is really messy. I wanted to collect
related functions, fix order (dependency) and name goups via comments.

Is there anything I should know? Patches are going to be huge, tons of
lines moved around the phy_n.c :(

Are there any objections against that? Any suggestions if I should
post one huge patch or few smaller ones?

-- 
Rafał

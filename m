Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbYFCS0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:26:21 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644244nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:26:20 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 00/11] rt2x00 update
Date: Tue, 3 Jun 2008 20:33:25 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806032033.25548.IvDoorn@gmail.com> (sfid-20080603_202625_376342_5D65AFF8)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I'm a bit fighting with rt2x00.git because I am trying
to reordering some patches that need to go upstream
earlier then the patches on which they depend. 
So this time the rt2x00 update is a patch series through mail only,
to make sure at least the main bulk of the changes is already
upstream while I'll sort out the remaining bugfix patches.

Some minor fixes, and several optmizations most notably the
register field handling has been optimized by doing more
work during compile time. This has a greatly reduced the module
size of each rt2x00 driver (~6KB reduction), and should have a
positive impact on runtime performance as well. :)

Ivo

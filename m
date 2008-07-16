Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:45003 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760844AbYGQRmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 13:42:33 -0400
Received: by wa-out-1112.google.com with SMTP id j37so10213waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 10:42:32 -0700 (PDT)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
From: Brian Cavagnolo <brian@cozybit.com>
Date: Tue, 15 Jul 2008 17:45:02 -0700
Subject: [PATCH 0/3] libertas: support for some persistent settings/features
Message-ID: <487f8484.1498600a.5fc5.33b2@mx.google.com> (sfid-20080717_194247_750602_6810C3F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some Marvell USB hardware, such as the OLPC Active Antenna, have writable
persistent settings for stand-alone use.  They also allow updates of the
bootloader and a stand-alone firmware image.  These patches add support for
some of these features and improve some existing support.



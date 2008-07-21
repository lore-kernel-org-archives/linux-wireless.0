Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:63372 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbYGUSrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 14:47:52 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1484497rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 11:47:51 -0700 (PDT)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
From: Brian Cavagnolo <brian@cozybit.com>
Date: Mon, 21 Jul 2008 11:05:43 -0700
Subject: [PATCH 0/3 RESEND] libertas: support for some persistent settings/features
Message-ID: <4884d9d6.02578c0a.49dd.fffffa11@mx.google.com> (sfid-20080721_204755_820284_86200B0F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some Marvell USB hardware, such as the OLPC Active Antenna, have writable
persistent settings for stand-alone use.  They also allow updates of the
bootloader and a stand-alone firmware image.  These patches add support for
some of these features and improve some existing support.


Signed-off-by: Brian Cavagnolo <brian@cozybit.com>



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65310 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZLBO3f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 09:29:35 -0500
Received: by bwz27 with SMTP id 27so217224bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 06:29:40 -0800 (PST)
Message-Id: <20091202142555.654873300@gmail.com>
Date: Wed, 02 Dec 2009 15:25:55 +0100
From: Holger Schurig <holgerschurig@googlemail.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 00/10] [PATCH] libertas: remove WEXT, add CFG80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is my current incarnation of the patch, after I managed today
to get IBSS and MONITOR working.

Especially the last patch is a "gem": 1984 lines added, but 6691 lines
deleted :-)

-- 

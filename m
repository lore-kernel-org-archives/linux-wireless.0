Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54061 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZGVF1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 01:27:54 -0400
Received: by fxm18 with SMTP id 18so3016628fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2009 22:27:53 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: reinette.chatre@intel.com
Subject: wireless-testing regression: iwl3945 scan fails
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Jul 2009 08:27:49 +0300
Message-ID: <87k521s2wa.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good morning,

I just upgraded to rc3-wl (commit 225b6807) and my iwl3945 doesn't work
anymore, even scan fails. I don't have time to investigate this right
now, but I'll try to find some time during the evening.

-- 
Kalle Valo

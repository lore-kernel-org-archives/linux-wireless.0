Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:51275 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846AbXKNKHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 05:07:35 -0500
Received: by an-out-0708.google.com with SMTP id b36so21194ana
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 02:07:34 -0800 (PST)
Message-ID: <1197ff4c0711140207s761be77g8756a434aefd33b9@mail.gmail.com> (sfid-20071114_100741_094405_889CFD44)
Date: Wed, 14 Nov 2007 18:07:32 +0800
From: "Li YanBo" <dreamfly281@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Agnx:Please pull agnx git
Cc: "Jeff willam" <angelbane@gmail.com>,
	agnx80211driver-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael

Base on we talked early, some problems have been fixed except replace
the calibrate timer with mac80211 workqueue, for the calibrate doesn't
work this moment, hence  I'll fixed it later . :)

the git repository at:

        http://git.sipsolutions.net/agnx.git

Agnx: Move alloc rings from function Probe to Start.
Agnx: Change spin_lock_irqsave to spin_lock in the interrupt context.
Agnx: Delete the line judge the dev_id is NULL
Agnx: Just reinit  tx packet that success sent in handle_tx

Regards

Li YanBo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56604 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1DOHJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 03:09:40 -0400
Received: by pzk9 with SMTP id 9so824847pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 00:09:40 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19879.61380.856831.769409@gargle.gargle.HOWL>
Date: Fri, 15 Apr 2011 12:42:04 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k_htc: Cleanup HTC debugfs
In-Reply-To: <20110415070626.GB23429@vmraj-lnx.users.atheros.com>
References: <1302848033-7072-1-git-send-email-rmanoharan@atheros.com>
	<1302848033-7072-2-git-send-email-rmanoharan@atheros.com>
	<19879.59459.480384.309998@gargle.gargle.HOWL>
	<20110415070626.GB23429@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> I think mac80211 handles debugfs_remove_recursive. isn't it?
> If so, Shall I remove it?

In that case, yep.

Sujith

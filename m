Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36440 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbbKMODD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 09:03:03 -0500
Received: by wmww144 with SMTP id w144so29940610wmw.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2015 06:03:01 -0800 (PST)
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: DFS Master Region
Message-ID: <5645ED92.3070105@gmail.com> (sfid-20151113_150306_918665_9A7C5B8D)
Date: Fri, 13 Nov 2015 15:02:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> I'm trying to understand a problem that some users are having with the 5G band 
> when using rtl8821ae. One of them sees the following output from cfg80211:
> [...]
> One other possible difference. My openSUSE system uses CRDA 1.1.3. The other box 
> runs Fedora 23 with an unknown version of CRDA.

Usually Fedora always brings latest software releases:
kernel-4.2.6-300.fc23.x86_64
crda-3.18_2015.10.22-1.fc23.x86_64 (crda-3.18 + wireless-regdb-2015.10.22)

You can try reproduce it in openSUSE with those releases.

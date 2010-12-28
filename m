Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46056 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab0L1Ikz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:40:55 -0500
Received: by ywl5 with SMTP id 5so3805945ywl.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 00:40:55 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 28 Dec 2010 02:40:52 -0600
Message-ID: <AANLkTi=MhYzv54WvEwYGh15KC4LHyM=EVd-s+1BG8pBT@mail.gmail.com>
Subject: Patches submitted should apply to which git repository?
From: Naveenan <initramd@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I would like to submit a patch to linux-wireless and was wondering
what git repository should my patch be apply-able to so that there
wouldn't be any merge conflicts?

I went through:
http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches
but couldn't find this information there so was hoping someone could
point the exact git repository. My current patch applies to
wireless-testing but doesn't apply to wireless-2.6 (due to a trivial
merge conflict) . The changes I'm making are to mac80211.

Thanks.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:42997 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbbAGA3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 19:29:40 -0500
Received: by mail-la0-f43.google.com with SMTP id s18so743471lam.2
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 16:29:39 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 6 Jan 2015 18:29:39 -0600
Message-ID: <CAAzPvNxFZSjqek25aWWAccpqV6zb_3CZOtk=-tDoCN_BO-bRiA@mail.gmail.com> (sfid-20150107_012958_004244_C40DCCBC)
Subject: mPCI or USB adapters with no AP mode station limits?
From: "C. B." <cbrookes@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Are there any either USB or mPCI devices that are known to NOT have
any connected station limits whilst operating in  AP mode?

My research has shown up the following as all having limits:

iwlwifi (http://comments.gmane.org/gmane.linux.kernel.wireless.general/131585)
ath9k_htc (http://comments.gmane.org/gmane.linux.drivers.ath9k.devel/12078)

... before I carry on digging around and looking at each driver I
thought I'd ask

CB

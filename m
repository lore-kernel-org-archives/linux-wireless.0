Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39663 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab2CCPDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 10:03:14 -0500
Received: by vbbff1 with SMTP id ff1so2305186vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Mar 2012 07:03:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F523162.6070306@openwrt.org>
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
	<CAD2nsn1epfw=N=Np8Ts+G6yF5JTXZXSE4bOL7_jY9mCZG9Cg4Q@mail.gmail.com>
	<4F523162.6070306@openwrt.org>
Date: Sat, 3 Mar 2012 20:33:14 +0530
Message-ID: <CAD2nsn3=5DrqZ7NJ7g6k4+RYobEFDs25-9eSiBsS1JhPAmc9kA@mail.gmail.com> (sfid-20120303_160318_012386_95838994)
Subject: Re: [PATCH 1/5] ath9k_hw: use cold instead of warm reset on AR9280
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What kind of issues do you expect from cold reset in STA mode? OpenWrt
> has had this patch for a while now, and I didn't notice any issues with it.

fine, would be better if this is done to specifically , like this
recovers the chip from tx hung like that.

>
> - Felix



-- 
thanks,
shafi

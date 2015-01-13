Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40613 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbbAMNrJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 08:47:09 -0500
From: Avinash Patil <patila@marvell.com>
To: wim torfs <wtorfs@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 13 Jan 2015 05:44:01 -0800
Subject: RE: mwifiex - question
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7AC0@SC-VEXCH2.marvell.com> (sfid-20150113_144717_857979_FD805831)
References: <1421065496-1968-1-git-send-email-patila@marvell.com>,<54B51EF1.60200@gmail.com>
In-Reply-To: <54B51EF1.60200@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wim,

Mwifiex is FullMac driver; we have our own thick FW for managing MLME.  This is reason why we do not use mac80211.
Mwifiex is very much located under drivers/net/wireless; its not in net/wireless. net/wireless has cfg80211 driver.

Thanks,
Avinash.
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of wim torfs [wtorfs@gmail.com]
Sent: Tuesday, January 13, 2015 7:04 PM
To: linux-wireless@vger.kernel.org
Subject: mwifiex - question

Hi,

I just noticed - from the mails passing through - that mwifiex is
located in net/wireless and that it contains its own functions besides
those of mac80211, while the description on the wiki mentions that it is
a driver for Marvell SDIO chips.

Is there any specific reason why it is not using mac80211 and why it is
located in net/wireless instead of drivers/net/wireless, or is this an
artifact of past choices that need to be cleaned up?

Thanks,
Wim.

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

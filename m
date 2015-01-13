Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:54190 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbbAMNeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 08:34:44 -0500
Received: by mail-wg0-f54.google.com with SMTP id z12so2934770wgg.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2015 05:34:43 -0800 (PST)
Received: from [192.168.5.12] (5ED13663.cm-7-2a.dynamic.ziggo.nl. [94.209.54.99])
        by mx.google.com with ESMTPSA id q10sm25747421wjx.34.2015.01.13.05.34.42
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 13 Jan 2015 05:34:42 -0800 (PST)
Message-ID: <54B51EF1.60200@gmail.com> (sfid-20150113_143449_177754_A67107E7)
Date: Tue, 13 Jan 2015 14:34:41 +0100
From: wim torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mwifiex - question
References: <1421065496-1968-1-git-send-email-patila@marvell.com>
In-Reply-To: <1421065496-1968-1-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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


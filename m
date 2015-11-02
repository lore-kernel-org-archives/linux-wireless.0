Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37137 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbbKBOEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 09:04:02 -0500
Received: by wmff134 with SMTP id f134so61422255wmf.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2015 06:04:01 -0800 (PST)
Received: from ?IPv6:2001:6a8:500:e076:b8a1:5dff:fe25:7954? ([2001:6a8:500:e076:b8a1:5dff:fe25:7954])
        by smtp.gmail.com with ESMTPSA id bk2sm22543565wjc.3.2015.11.02.05.55.40
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Nov 2015 05:55:40 -0800 (PST)
Message-ID: <56376B5B.7070608@gmail.com> (sfid-20151102_150407_408826_C4F35318)
Date: Mon, 02 Nov 2015 14:55:39 +0100
From: Wim Torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211 chanctx usage
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

What is the idea behind channel contexts? Is it just to create an 
abstraction between the different vifs regarding the channel (each vif 
is allowed to operate on its own channel)? In case I want just a single 
vif, can I ignore the chanctx (specify that the driver does not support 
chanctx) or is this not recommended due perhaps some updates that were 
done on the chanctx code and not on the alternative branch?






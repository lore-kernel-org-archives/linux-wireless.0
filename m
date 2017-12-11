Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nsmtp.uni-koblenz.de ([141.26.64.14]:43051 "EHLO
        nsmtp.uni-koblenz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752367AbdLKNvg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 08:51:36 -0500
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
From: =?UTF-8?Q?Richard_Sch=c3=bctz?= <rschuetz@uni-koblenz.de>
Subject: 76f43b4 fix for stable
Message-ID: <c0a512a7-e615-bbab-5c88-4a85946fefb5@uni-koblenz.de> (sfid-20171211_145144_843553_B9CBDEA2)
Date: Mon, 11 Dec 2017 14:51:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

as per netdev-FAQ.txt I'm requesting the submission of commit 
57629915d568c522ac1422df7bba4bee5b5c7a7c ("mac80211: Fix addition of 
mesh configuration element") to stable. Because of automatic selection 
commit 76f43b4c0a9337af22827d78de4f2b8fd5328489 ("mac80211: Remove 
invalid flag operations in mesh TSF synchronization") was introduced 
into stable recently without this accompanying fix.

-- 
Richard

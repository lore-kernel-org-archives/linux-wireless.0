Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:37109 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdKVKNb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 05:13:31 -0500
Received: by mail-qk0-f176.google.com with SMTP id 136so15994088qkd.4
        for <linux-wireless@vger.kernel.org>; Wed, 22 Nov 2017 02:13:31 -0800 (PST)
Subject: Re: [EXT] Marvell Mwifiex wireless driver: mwifiex_pcie broken on
 Marvell ESPRESSOBin
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
References: <6dc0221c-c7ec-d107-02e8-0ab443807e51@gmail.com>
 <a4233e0d08f1400fa30ef112e0fda464@SC-EXCH02.marvell.com>
From: Ellie Reeves <ellierevves@gmail.com>
Message-ID: <7d8c7705-70ac-9a36-b5d2-23fcffcf6a29@gmail.com> (sfid-20171122_113257_309409_703522D5)
Date: Wed, 22 Nov 2017 05:13:26 -0500
MIME-Version: 1.0
In-Reply-To: <a4233e0d08f1400fa30ef112e0fda464@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
is the recent patch for mwifiex the one Ganapathi was talking about, to 
fix mwifiex on espressobin ? If so, I tried it (in v1 I admit), without 
no real change. The interface is no longer shown as 'no-carrier' but 
there is still the timeout, and all the messages about fw being in bad 
state. :/ Sorry if I confused the patch with something unrelated to the 
espressobin.

-- 
Ellie Reeves

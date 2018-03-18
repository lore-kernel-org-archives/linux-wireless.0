Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skyhawk.myhost.co.nz ([120.138.17.237]:34188 "EHLO
        skyhawk.myhost.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754155AbeCRXhI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 19:37:08 -0400
Subject: Re: [PATCH] mac80211: add ieee80211_hw flag for QoS NDP support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20180317205118.21227-1-ben@transient.nz>
 <201803190525.Ycp9pnWN%fengguang.wu@intel.com>
From: Ben Caradoc-Davies <ben@transient.nz>
Message-ID: <65743b46-85e2-6833-ea2b-372d24055108@transient.nz> (sfid-20180319_003711_545715_5212EACA)
Date: Mon, 19 Mar 2018 12:36:58 +1300
MIME-Version: 1.0
In-Reply-To: <201803190525.Ycp9pnWN%fengguang.wu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/03/18 11:12, kbuild test robot wrote:
>     net/mac80211/debugfs.c: In function 'hwflags_read':
>>> include/linux/compiler.h:339:38: error: call to '__compiletime_assert_234' declared with attribute error: BUILD_BUG_ON failed: ARRAY_SIZE(hw_flag_names) != NUM_IEEE80211_HW_FLAGS

Please reject this patch. I will submit a revised patch that adds the 
new flag to hw_flag_names in net/mac80211/debugfs.c.

Kind regards,

-- 
Ben Caradoc-Davies <ben@transient.nz>
Director
Transient Software Limited <https://transient.nz/>
New Zealand

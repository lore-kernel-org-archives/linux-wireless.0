Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skyhawk.myhost.co.nz ([120.138.17.237]:48821 "EHLO
        skyhawk.myhost.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754150AbeCUXLz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 19:11:55 -0400
Subject: Re: [PATCH] mac80211: add ieee80211_hw flag for QoS NDP support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20180318235744.3527-1-ben@transient.nz>
 <1521626030.2645.24.camel@sipsolutions.net>
From: Ben Caradoc-Davies <ben@transient.nz>
Message-ID: <4a3b8476-edf0-09e9-c762-3c044f77f940@transient.nz> (sfid-20180322_001201_349990_881EEF72)
Date: Thu, 22 Mar 2018 12:11:47 +1300
MIME-Version: 1.0
In-Reply-To: <1521626030.2645.24.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21/03/18 22:53, Johannes Berg wrote:
> I've applied a modified version of this patch - it will also require
> setting the new "broken" flag in the driver.

Thanks very much, Johannes. I have tested your modified patch 
<https://patchwork.kernel.org/patch/10299025/> together with the patch 
<https://patchwork.kernel.org/patch/10299031/> that enables the new 
"broken" flag and they seem to fix the problem (when backported to 
Debian 4.15.11-1).

Kind regards,

-- 
Ben Caradoc-Davies <ben@transient.nz>
Director
Transient Software Limited <https://transient.nz/>
New Zealand

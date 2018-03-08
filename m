Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skyhawk.myhost.co.nz ([120.138.17.237]:47729 "EHLO
        skyhawk.myhost.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755079AbeCHMjx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 07:39:53 -0500
Subject: Re: [PATCH] Revert "mac80211: use QoS NDP for AP probing"
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20180225211541.29931-1-ben@transient.nz>
 <1519725888.4086.3.camel@sipsolutions.net>
From: Ben Caradoc-Davies <ben@transient.nz>
Message-ID: <f5976d04-8501-ece5-3f60-98d00b1e01e5@transient.nz> (sfid-20180308_133956_759129_E0125532)
Date: Fri, 9 Mar 2018 01:39:47 +1300
MIME-Version: 1.0
In-Reply-To: <1519725888.4086.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/02/18 23:04, Johannes Berg wrote:
> It seems to be a particular driver problem, so blindly reverting seems
> a bit heavy-handed.

Johannes, perhaps you could temporarily revert commit 7b6ddeaf27ec 
("mac80211: use QoS NDP for AP probing") until you have an 
implementation that does not break ath9k_htc.

Kind regards,

-- 
Ben Caradoc-Davies <ben@transient.nz>
Director
Transient Software Limited <https://transient.nz/>
New Zealand

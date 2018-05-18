Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:41799 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751429AbeERKk4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 06:40:56 -0400
Subject: Re: [PATCH] ath10k: add dynamic vlan support
To: Johannes Berg <johannes@sipsolutions.net>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
 <63f12b0c-02e9-0ad2-28a0-d0bbc858e76a@dd-wrt.com>
 <1526637184.3805.14.camel@sipsolutions.net>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <89904253-7a31-6182-d976-264b78fc3a10@dd-wrt.com> (sfid-20180518_124059_747549_607FA121)
Date: Fri, 18 May 2018 12:40:55 +0200
MIME-Version: 1.0
In-Reply-To: <1526637184.3805.14.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 18.05.2018 um 11:53 schrieb Johannes Berg:
> On Mon, 2018-04-23 at 21:18 +0200, Sebastian Gottschall wrote:
>> this patch makes no sense at some points. AP_VLAN must be enabled always
>> (it is enabled by mac80211 by default, but is now disabled in very
>> latest git version for drivers which announce sw_crypto support)
>> if its disabled wds ap / wds sta operation will not work anymore since
>> mac80211 uses AP_VLAN for the local wds sta interfaces
> You'd do you well to learn the correct terminology used in Linux if you
> try to communicate with us...
>
> What you say there makes no sense, WDS is a separate mode. Maybe you
> mean 4-addr mode?
yes 4-addr mode which is common known as WDS mode. (terminology used by 
all sorts of vendors)

Sebastian
>
> johannes
>

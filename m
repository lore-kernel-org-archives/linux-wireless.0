Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:54852 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYHQW5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 18:57:15 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1958266fkq.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Aug 2008 15:57:13 -0700 (PDT)
Message-ID: <1ba2fa240808171557w4eecb005s68286d9391a3f15b@mail.gmail.com> (sfid-20080818_005719_624093_A5878D33)
Date: Mon, 18 Aug 2008 01:57:13 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 00/15] iwlwifi driver 08/15 updates
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 15, 2008 at 5:01 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> Hi,
>
> Here are some fix and cleanup for iwlwifi and mac80211.  Note mac80211
> patches 07~10 are already submitted by Tomas Winkler before.
>
> Thanks,
> -yi
>
I would just merge everyting into 2.6.27 but here are important
changes from my point of view (4965 and 5000)

> [PATCH 01/15] iwlwifi: Added bss_info_changed callback to 3945

> [PATCH 02/15] iwlwifi: W/A for the TSF correction in IBSS
For 2.6.27 -Fixes IBSS connectivity - constant merging

> [PATCH 03/15] iwlwifi: clean up hw scan handler
Needed for dependencies.

> [PATCH 04/15] iwlwifi: remove obsolete 4965 forward declarations

> [PATCH 05/15] iwlwifi: allow consecutive scans in unassociated state
> [PATCH 06/15] iwlwifi: align set channel with mac80211
For 2.6.27 (hidden SSID connectivity)

> [PATCH 07/15] mac80211: filter probes in ieee80211_rx_mgmt_probe_resp
> [PATCH 08/15] mac80211: cleanup mlme state namespace
> [PATCH 09/15] mac80211: change number of pre-assoc scans
> [PATCH 10/15] mac80211: add direct probe before association

For 2.6.27 mac patches - enable hidden SSID connectivity and more
robust connection in general

> [PATCH 11/15] iwl3945: fix unbalanced mutex
> [PATCH 12/15] iwl3945: replace association and beacon hooks with bss_info_changed cb

> [PATCH 13/15] iwlwifi: fix hidden ssid discovery in passive channels
For 2.6.27 enable hidden SSID in 5.2 Band

> [PATCH 14/15] iwl3945: removed bg_post_associate work
> [PATCH 15/15] iwl3945: avoid redundant iwl3945_get_active_dwell_time
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks
Tomas

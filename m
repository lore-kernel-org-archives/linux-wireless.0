Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f175.google.com ([209.85.210.175]:61621 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2LGWl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 17:41:56 -0500
Received: by mail-ia0-f175.google.com with SMTP id z3so1548916iad.6
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 14:41:55 -0800 (PST)
Date: Fri, 7 Dec 2012 17:41:10 -0500
From: Bob Copeland <me@bobcopeland.com>
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, Mike Krinkin <krinkin.m.u@gmail.com>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	linux-wireless@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [RFCv3 4/5] mac80211: mesh power save basics
Message-ID: <20121207224110.GE535@localhost> (sfid-20121207_234159_152467_70BB5A86)
References: <1354918443-3076-1-git-send-email-marco@cozybit.com>
 <1354918443-3076-5-git-send-email-marco@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1354918443-3076-5-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 07, 2012 at 02:14:02PM -0800, Marco Porsch wrote:
> +void ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
> +				    enum nl80211_mesh_power_mode pm,
> +				    u32 delay);
> +void ieee80211_mps_sta_local_pm_timer(unsigned long data);
> +void ieee80211_msp_set_frame_flags(struct ieee80211_sub_if_data *sdata,
> +				   struct sta_info *sta,
> +				   struct ieee80211_hdr *hdr);

Does "msp" mean anything, or is it supposed to be mps like the others?

-- 
Bob Copeland %% www.bobcopeland.com

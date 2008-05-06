Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:19832 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbYEFJJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 05:09:11 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1581943rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 02:09:10 -0700 (PDT)
Message-ID: <1ba2fa240805060209x3765abf6lf5ece51055b0d60@mail.gmail.com> (sfid-20080506_110824_774332_F90FDACC)
Date: Tue, 6 May 2008 12:09:10 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 25/25] iwlwifi: map A-MPDU HW queue to mac80211 A-MPDU SW queue
Cc: linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1209954172-3092-26-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-25-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-26-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 5, 2008 at 5:22 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>
>  This patch maps A-MPDU HW queue to mac80211 SW queue scheme (as introduced
>  in patch "mac80211: QoS related cleanups"), when trying to perform
>  ieee80211_wake_queue.
>
>  Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>

Is this going to make it to 2.6.26?
Without this it will be hard to run 5000 under 2.6.26 as is.

Thanks
Tomas

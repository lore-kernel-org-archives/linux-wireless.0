Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:9081 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbYAHPIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 10:08:05 -0500
Received: by rv-out-0910.google.com with SMTP id k20so7497011rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2008 07:08:04 -0800 (PST)
Message-ID: <c85cb4470801080708l3b0811e4pb74f33b48bb0c3e5@mail.gmail.com> (sfid-20080108_150811_909425_6BF8DF07)
Date: Tue, 8 Jan 2008 17:08:04 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Subject: Re: [PATCH 0/8 v3] mac80211/iwlwifi: integrate IEEE802.11n A-MPDU Rx MLME
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com, yi.zhu@intel.com,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <1198848559.4103.112.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
	 <1198848559.4103.112.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > This series of patches contains implementation for the IEEE802.11n
> > aggregated MPDUs (A-MPDU) MLME. The series handles Rx A-MPDU
>
> Looks fine to me. John, we could probably merge 1-7 as a single patch, I
> don't see much point in splitting it up in the final tree. It was good
> for reviewing but I don't see why we want that in the tree later. Don't
> care much though.
> johannes

Hi John, what is the status for this merge? It blocks me on the Tx as
i need this basic MLME framework series, along with the preliminary
"mac80211: restructure __ieee80211_rx" patch that was Acked as well.
thanks
ron
BTW - i already rebased them to rc7, if you prefer i can send them over.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:36622 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYIPJAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 05:00:54 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1644059fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 02:00:51 -0700 (PDT)
Message-ID: <1ba2fa240809160200q4f270f68v92d9942ac5b7d035@mail.gmail.com> (sfid-20080916_110234_677025_8290326C)
Date: Tue, 16 Sep 2008 12:00:51 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] iwlwifi: don't delay scan in IBSS mode
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221547983.8916.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221544864-9494-1-git-send-email-yi.zhu@intel.com>
	 <1221547983.8916.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 16, 2008 at 9:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-09-16 at 14:01 +0800, Zhu Yi wrote:
>> From: Tomas Winkler <tomas.winkler@intel.com>
>>
>> Scan need to be delayed only after association to allow EAPOL
>> exchange. We don't need the delay for IBSS mode.
>
> FWIW, I'd love to see that delay thing moved into mac80211.

I'm just looking into this new scan proposals.
Tomas

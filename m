Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34926 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbHZRRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 13:17:19 -0400
Received: by labgv11 with SMTP id gv11so56401705lab.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2015 10:17:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Wed, 26 Aug 2015 20:17:17 +0300
Message-ID: <CANUX_P1B3ZtdcUKVczobuL_hYkesFEpMK92sNQTUNNexXtuBHA@mail.gmail.com> (sfid-20150826_191723_027951_4518F982)
Subject: Re: [RFC 0/5] cfg80211 / mac80211: add support for Neighbor Awareness Networking
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Qiumin Hu <qiumin.hu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2015 at 5:14 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> This patch series add supports for a new WiFi feature called
> Neighbor Awareness Networking a.k.a. NAN.

Quite a few people contacted me on that matter. Several contacted me
privately, others through IRC.
I am not sending this series as PATCH since we are not ready on the
driver level. And we typically don't want to have APIs that nobody
uses. iwlwifi should start supporting NAN early next year (no
commitment whatsoever of course).
Since I had no comments on this, I think the API is pretty much ready
which means that if some courageous application developer wants to
start using NAN, I think he can that he can take a decently safe
assumption that the API will look as described in this patch series.

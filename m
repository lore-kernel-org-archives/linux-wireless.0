Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35748 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbGIT0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 15:26:15 -0400
Received: by labgy5 with SMTP id gy5so100209170lab.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 12:26:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435952472-22752-4-git-send-email-me@bobcopeland.com>
References: <1435952472-22752-1-git-send-email-me@bobcopeland.com>
	<1435952472-22752-4-git-send-email-me@bobcopeland.com>
Date: Thu, 9 Jul 2015 15:26:13 -0400
Message-ID: <CAEKwDSCiF-Bb2ywWM8Reo6sQtDDuLZuditDzLvfXEaK5W-uCVw@mail.gmail.com> (sfid-20150709_212619_451013_38B95EFF)
Subject: Re: [PATCH v2 3/3] mac80211: select an AID when creating new mesh STAs
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org, Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 3, 2015 at 3:41 PM, Bob Copeland <me@bobcopeland.com> wrote:
> Instead of using peer link id for AID, generate a new
> AID when creating mesh STAs in the kernel peering manager.

I missed a case where llid was used for aid in
ieee80211_mps_frame_release() -- will send a v3 for the series.

-- 
Bob Copeland %% www.bobcopeland.com

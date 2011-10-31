Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59784 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab1JaJQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:16:24 -0400
Received: by bkbzt4 with SMTP id zt4so1915366bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 02:16:22 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Pedersen <thomas@cozybit.com>
Subject: Re: [PATCH 2/4] mac80211: QoS multicast frames have No Ack policy
Date: Mon, 31 Oct 2011 10:16:17 +0100
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net, linville@tuxdriver.com
References: <1319864732-11286-1-git-send-email-thomas@cozybit.com> <201110291140.12311.chunkeey@googlemail.com> <CAG6hwVPNfqriCij5p3Lia2+=ob0AwQjPQFXUssumvBMvu51qTg@mail.gmail.com>
In-Reply-To: <CAG6hwVPNfqriCij5p3Lia2+=ob0AwQjPQFXUssumvBMvu51qTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201110311016.17604.chunkeey@googlemail.com> (sfid-20111031_101634_987385_E135B04E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, October 31, 2011 08:03:12 AM Thomas Pedersen wrote:
> On Sat, Oct 29, 2011 at 2:40 AM, Christian Lamparter <chunkeey@googlemail.com> wrote:
> > ack_policy = *ieee80211_get_qos_ctl(hdr) & ~IEEE80211_QOS_CTL_ACK_POLICY_MASK;
> 
> Good idea. Will fix and resubmit.

hmpf, make that: (stupid c&p typo :) )
ack_policy = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_ACK_POLICY_MASK;

Regards,
	Chr

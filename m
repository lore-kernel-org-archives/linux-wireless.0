Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab0CJUcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 15:32:18 -0500
Received: by pwj5 with SMTP id 5so470657pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Mar 2010 12:32:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100310152134.GC2969@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
	<20100310152134.GC2969@dhcp-lab-161.englab.brq.redhat.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Mar 2010 12:31:58 -0800
Message-ID: <43e72e891003101231nc3cb3d3u3b1815a72e8e80fc@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: disable_qos callback
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 10, 2010 at 7:21 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Add disable_qos callback and use it when AP do not send
> QoS (WMM) information.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

What's the justification of a new callback for this? Can we not do
this through the general conf?

  Luis

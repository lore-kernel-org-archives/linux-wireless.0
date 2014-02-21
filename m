Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:40979 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbaBUXgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 18:36:41 -0500
Received: by mail-la0-f43.google.com with SMTP id pv20so2923579lab.2
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 15:36:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392896671-4288-2-git-send-email-ilan.peer@intel.com>
References: <1392896671-4288-1-git-send-email-ilan.peer@intel.com> <1392896671-4288-2-git-send-email-ilan.peer@intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 15:36:20 -0800
Message-ID: <CAB=NE6X4a5QWhFHXtp2KSvMTo2U8f2=NhX0o-pG3Kb7Rpxqj=A@mail.gmail.com> (sfid-20140222_003645_641372_AE76561E)
Subject: Re: [PATCH v5 1/5] cfg80211: Add indoor only and GO concurrent
 channel attributes
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Spinadel <david.spinadel@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 3:44 AM, Ilan Peer <ilan.peer@intel.com> wrote:
> From: David Spinadel <david.spinadel@intel.com>
>
> The FCC are clarifying some soft configuration requirements,
> which among other include the following:
>
> 1. Indoor operation, where a device can use channels requiring indoor
>    operation, subject to that it can guarantee indoor operation,
>    i.e., the device is connected to AC Power or the device is under
>    the control of a local master that is acting as an AP and is
>    connected to AC Power.
> 2. Concurrent GO operation, where devices may instantiate a P2P GO
>    while they are under the guidance of an authorized master. For example,
>    on a channel on which a BSS is connected to an authorized master, i.e.,
>    with DFS and radar detection capability in the UNII band.
>
> See https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122
>
> Add support for advertising Indoor-only and GO-Concurrent channel
> properties.
>
> Signed-off-by: David Spinadel <david.spinadel@intel.com>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis

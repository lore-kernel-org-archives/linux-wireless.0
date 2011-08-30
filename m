Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45493 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1H3W0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 18:26:05 -0400
Received: by qwk3 with SMTP id 3so100446qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 15:26:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314740334-10341-2-git-send-email-s.neumann@raumfeld.com>
References: <20110830191437.GC2660@tuxdriver.com> <1314740334-10341-1-git-send-email-s.neumann@raumfeld.com>
 <1314740334-10341-2-git-send-email-s.neumann@raumfeld.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Aug 2011 15:25:45 -0700
Message-ID: <CAB=NE6WBrKK4NZ80w9-mO36pJ-VNonshuG_E7Sbhoiaz+Hcf5A@mail.gmail.com> (sfid-20110831_002610_312428_F91485A7)
Subject: Re: [PATCH 2/2] cfg80211: reorder code to obsolete forward declaration
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Mack <daniel@zonque.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 2:38 PM, Sven Neumann <s.neumann@raumfeld.com> wrote:
> Reorder functions to remove the need for a forward declaration
> introduced by the last commit.
>
> Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> Cc: Daniel Mack <daniel@zonque.org>
> Cc: linux-wireless@vger.kernel.org

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

  Luis

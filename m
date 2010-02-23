Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63619 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab0BWT3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 14:29:03 -0500
Received: by pwj8 with SMTP id 8so4104224pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 11:29:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7F2FE3504A6CB54497542A539E401A7B6AB18057@DEMCHP99E15MSX.ww902.siemens.net>
References: <7F2FE3504A6CB54497542A539E401A7B6AB18057@DEMCHP99E15MSX.ww902.siemens.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Feb 2010 11:28:43 -0800
Message-ID: <43e72e891002231128l4b776d09k36a10013f5aadf31@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix PREQ processing and one small bug
To: "Porsch, Marco" <marco.porsch@siemens.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 2:35 AM, Porsch, Marco <marco.porsch@siemens.com> wrote:
> 1st) a PREQ should only be processed, if it has the same SN and better metric (instead of better or equal).
> 2nd) next_hop[ETH_ALEN] now actually used to buffer mpath->next_hop->sta.addr for use out of lock.
>
> Signed-off-by: Marco Porsch <marco.porsch@siemens.com>
> Acked-by: Javier Cardona <javier@cozybit.com>

Cc: stable@kernel.org ?

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56171 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2GWTWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 15:22:00 -0400
Received: by yhmm54 with SMTP id m54so5852603yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 12:22:00 -0700 (PDT)
Date: Mon, 23 Jul 2012 15:20:17 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: jirislaby@gmail.com, johannes.berg@intel.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, nbd@nbd.name
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: fix phy_init() to respect
 user txpower changes
Message-ID: <20120723192017.GA5229@localhost> (sfid-20120723_212205_146939_4AEB3D46)
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <20120723164250.GA11893@localhost>
 <500D9716.10300@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <500D9716.10300@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 23, 2012 at 08:25:26PM +0200, Thomas Huehn wrote:
> > Did this / 2 move elsewhere or was it wrong before?  Is txp_cur_pwr still
> > used for anything?
> 
> the "/2" is not needed anymore as I also skipped the "*2" in
> ath5k_hw_set_txpower_limit .. so I avoid this calculations.
> 
> Felix is goint to use txp_cur_pwr, so for now it is not used ... maybe
> he can explain where it will be needed.

Ok great, thanks for the clarification.

-- 
Bob Copeland %% www.bobcopeland.com

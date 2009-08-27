Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:58190 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZH0SRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 14:17:46 -0400
Received: by vws33 with SMTP id 33so1043523vws.33
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 11:17:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
	 <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
Date: Thu, 27 Aug 2009 14:17:47 -0400
Message-ID: <b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
From: Bob Copeland <bcopeland@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 8:58 AM, Nick Kossifidis<mickflemm@gmail.com> wrote:
> 2009/8/27 Pavel Roskin <proski@gnu.org>:

> Current code works fine (i 've checked it against various cards),
> there is nothing wrong
> with having another function for reading turbo modes, i find it's
> cleaner that way.

Well, we also don't use the turbo modes at all and that's where the
error is (IIRC) so it shouldn't have any impact. :)

-- 
Bob Copeland %% www.bobcopeland.com

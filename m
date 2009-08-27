Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:61903 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZH0DnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 23:43:08 -0400
Received: by vws33 with SMTP id 33so592681vws.33
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 20:43:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090827023000.21926.90867.stgit@mj.roinet.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
Date: Wed, 26 Aug 2009 23:43:09 -0400
Message-ID: <b6c5339f0908262043x490cd51eh297d9289f58acd31@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 10:30 PM, Pavel Roskin<proski@gnu.org> wrote:
> The `val' variable in ath5k_eeprom_read_turbo_modes() is used
> uninitialized.  gcc 4.4.1 with -fno-inline-functions-called-once reports
> it:
>
> eeprom.c: In function 'ath5k_eeprom_read_turbo_modes':
> eeprom.c:441: warning: 'val' may be used uninitialized in this function

Thanks!

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

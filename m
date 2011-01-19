Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35902 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab1ASPSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 10:18:16 -0500
Received: by qwa26 with SMTP id 26so941887qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 07:18:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101192052.53702.br1@einfach.org>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092057.19628.9296.stgit@localhost6.localdomain6>
	<AANLkTi=2crGZhucAhNHU-iaOkRamg33tQo_-K5h9d64v@mail.gmail.com>
	<201101192052.53702.br1@einfach.org>
Date: Wed, 19 Jan 2011 10:18:15 -0500
Message-ID: <AANLkTinyFXy3s_Q29zzs=SALXc1v_aT3xJU3b=DO316J@mail.gmail.com>
Subject: Re: [PATCH 5/8] ath5k: Add 802.11j 4.9GHz channels to allowed channels
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 6:52 AM, Bruno Randolf <br1@einfach.org> >
That's also the reason why we need to know the band:
>
> in 2GHz all channels < 14 are allowed.
> in 5GHz only a few.
>
> Thanks for your review!

Oh, I get it now, yes, that makes sense :)

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

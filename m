Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:49788 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848AbZEMSvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 14:51:45 -0400
Received: by pzk13 with SMTP id 13so343764pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 11:51:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090513182524.GF2680@tuxdriver.com>
References: <20090513151439.GA28476@hash.localnet>
	 <20090513182524.GF2680@tuxdriver.com>
Date: Wed, 13 May 2009 14:51:46 -0400
Message-ID: <b6c5339f0905131151u5dd10673pbe3cbf0fe0fed1a9@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix exp off-by-one when computing
	OFDM delta slope
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, forrest@hifulltech.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 2:25 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> That's fine. =A0But what about this last bit?
>
> =A0 =A0 =A0 =A0http://bugzilla.kernel.org/show_bug.cgi?id=3D13077#c6
>
> Is that not needed?

I think it is needed, but I checked back through 2.6.27 and it has the
same (probably buggy) code, so I think that's less urgent.  Also it
conflicts with the race condition fixes I sent earlier so it is better
in a separate patch.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

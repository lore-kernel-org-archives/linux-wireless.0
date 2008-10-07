Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:48857 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYJGMTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 08:19:13 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3535198rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 05:19:12 -0700 (PDT)
Message-ID: <b6c5339f0810070519i313b6889ga2b8a03a6c5e69a2@mail.gmail.com> (sfid-20081007_141920_046822_CC26BD1E)
Date: Tue, 7 Oct 2008 08:19:12 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Cc: toralf.foerster@gmx.de, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com
In-Reply-To: <873aj8vg45.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com>
	 <20081002144600.M31352@bobcopeland.com>
	 <87bpy32c1w.fsf@denkblock.local>
	 <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
	 <20081003134648.M45120@bobcopeland.com>
	 <87fxnd2112.fsf@denkblock.local>
	 <20081003193739.M19356@bobcopeland.com>
	 <877i8nky65.fsf@denkblock.local> <20081007013529.GA9691@hash.localnet>
	 <873aj8vg45.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 7, 2008 at 6:44 AM, Elias Oltmanns <eo@nebensachen.de> wrote:
>> -ath5k_stop_hw(struct ath5k_softc *sc)
>> +ath5k_stop_hw(struct ath5k_softc *sc, bool update_status)
>                                              ^^^^^^^^^^^^^
> That should be is_suspend for the sake of consistency.

Crap, I must've sent the wrong version.  Same for the broken boolean test,
I had that fixed already.  Sigh, one more on the way...

-- 
Bob Copeland %% www.bobcopeland.com

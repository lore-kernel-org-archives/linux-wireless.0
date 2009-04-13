Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:21633 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbZDMRLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 13:11:38 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2166144rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 10:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910904130957o68d24c90pf49f44f8db60ece4@mail.gmail.com>
References: <20090410213958.GA12571@hell.pl>
	 <20090411171955.76c48709@vroon.org> <20090413162439.GA30220@hell.pl>
	 <69e28c910904130957o68d24c90pf49f44f8db60ece4@mail.gmail.com>
Date: Mon, 13 Apr 2009 13:11:36 -0400
Message-ID: <b6c5339f0904131011t47e37c5cpf1b75ab0b171e8d9@mail.gmail.com> (sfid-20090413_191142_267237_DB033F03)
Subject: Re: ath5k blind to nearby network
From: Bob Copeland <me@bobcopeland.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Grzegorz Nowakowski <krecik@hell.pl>, Tony Vroon <tony@vroon.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/13 G=E1bor Stefanik <netrolller.3d@gmail.com>:
> Windows XP auto-configures the regulatory domain based on your
> regional settings. Intel cards have semi-hardcoded regulatory
> information in their EEPROMs, which allows Linux to automatically
> select the right regulatory settings. Atheros cards have no such
> firmware-level regulatory enforcement.

=2E..yet.  Actually ath9k does, and there are patches for ath5k.

However, a lot of cards are programmed to be world roaming in the
eeprom too.  So 'iw reg set XX' is still your best bet.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

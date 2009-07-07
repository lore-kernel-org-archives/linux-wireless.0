Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:51981 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZGGTnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 15:43:43 -0400
Received: by gxk26 with SMTP id 26so2281939gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2009 12:43:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246994723.3393.14.camel@mj>
References: <1246959589.4686.1.camel@debian-tomek>
	 <b6c5339f0907070719l2db5aec3rc20160eabd41fd0a@mail.gmail.com>
	 <1246994723.3393.14.camel@mj>
Date: Tue, 7 Jul 2009 15:43:42 -0400
Message-ID: <b6c5339f0907071243i7380ef9cm857fd189025a92a9@mail.gmail.com>
Subject: Re: ath5k and ap mode
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: tomek <paladyn11@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 7, 2009 at 3:25 PM, Pavel Roskin<proski@gnu.org> wrote:
>
> WPA: Countermeasures - dropped EAPOL request.
>
> I'm using WPA-PSK (WPA1 only) to simplify the configuration.  My
> impression is that we need a serious effort to weed out such problems.

Hmm, does the same happen with nohwcrypt=1?

ISTR ath9k had a patch sometime last year having to do with the key
cache and AP mode, probably applies here too.

-- 
Bob Copeland %% www.bobcopeland.com

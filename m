Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:48067 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZHTOqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 10:46:50 -0400
Received: by fxm17 with SMTP id 17so490026fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 07:46:50 -0700 (PDT)
To: gregor kowski <gregor.kowski@gmail.com>
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv4] b43 add harware tkip
References: <83a869cd0908191335u723f62c6p119ec4ed8cfb51c5@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 20 Aug 2009 17:46:47 +0300
In-Reply-To: <83a869cd0908191335u723f62c6p119ec4ed8cfb51c5@mail.gmail.com> (gregor kowski's message of "Wed\, 19 Aug 2009 22\:35\:45 +0200")
Message-ID: <87eir6tueg.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gregor kowski <gregor.kowski@gmail.com> writes:

> Update v4 : add a warn_on in b43_op_update_tkip_key, update to last
> driver change (key API).
> Update v3 : add a module parameter to enable hw tkip, Coding style
> fix, locking fix
> Update v2 : work with qos, implement dump key, fix an issue with setting
> random value on tkip key clear.

It's recommended to not include changelog (ie v3, v4 and so on) in the
patch description. Either add it after "-- \n" mark or send a separate
cover letter.

-- 
Kalle Valo
